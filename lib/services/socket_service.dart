import 'dart:convert';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:demo25/enums/fc_event.dart';
import 'package:demo25/models/remote/socket_config.dart';
import 'package:demo25/services/local_storage/hive/hive_service.dart';
import 'package:demo25/services/local_storage/isar/isar_service.dart';
import 'package:demo25/utils/constants.dart';
import 'package:demo25/utils/singletons.dart';
import 'package:logger/logger.dart';

abstract class SocketService {
  SocketConfig defaultConfig();
  Future<void> init({required SocketConfig socketConfig});
}

class SocketServiceImpl implements SocketService {
  SocketServiceImpl({required IsarService isarService}) {
    _isarService = isarService;
  }

  late IsarService _isarService;

  PusherChannelsClient _initClient() {
    final hostOptions = PusherChannelsOptions.fromHost(
      scheme: FCConfig.instance!.values.socketScheme,
      host: FCConfig.instance!.values.socketDomain,
      key: FCConfig.instance!.values.socketKey,
      port: FCConfig.instance!.values.socketPort,
    );

    return PusherChannelsClient.websocket(
      options: hostOptions,
      connectionErrorHandler: (exception, trace, refresh) {
        Logger().f(exception);
        Logger().f(trace);

        refresh();
      },
      activityDurationOverride: const Duration(seconds: 120),
    );
  }

  Future<void> _connectClient({required PusherChannelsClient client}) async {
    await client
        .connect()
        .then((onValue) {
          Logger().i('Successfully connected to the socket server');
        })
        .onError((error, stackTrace) {
          Logger().e(
            'An error occured connecting to the socket server',
            error: error,
            stackTrace: stackTrace,
          );
        });
  }

  PrivateChannel _registerToPrivateChannel({
    required PusherChannelsClient client,
    required String channelName,
  }) {
    final token = getIt<HiveService>().auth.retrieveToken();

    return client.privateChannel(
      'private-$channelName',
      authorizationDelegate:
          // ignore: lines_longer_than_80_chars
          EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
            authorizationEndpoint: Uri.parse(
              '${FCConfig.instance!.values.baseUrl}/broadcasting/auth',
            ),
            onAuthFailed: (exception, trace) {
              Logger().e(exception);
              Logger().f(trace);
            },
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
    );
  }

  PresenceChannel _registerToPresenceChannel({
    required PusherChannelsClient client,
    required String channelName,
  }) {
    final token = getIt<HiveService>().auth.retrieveToken();

    return client.presenceChannel(
      'presence-$channelName',
      authorizationDelegate:
          // ignore: lines_longer_than_80_chars
          EndpointAuthorizableChannelTokenAuthorizationDelegate.forPresenceChannel(
            authorizationEndpoint: Uri.parse(
              '${FCConfig.instance!.values.baseUrl}/broadcasting/auth',
            ),
            onAuthFailed: (exception, trace) {
              Logger().e(exception);
              Logger().e(trace);
            },
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
    );
  }

  void _subscribeToPrivateChannelsEvent({
    required PusherChannelsClient client,
    required List<Channel> channels,
  }) {
    client.onConnectionEstablished.listen((_) {
      for (final channel in channels) {
        channel.subscribeIfNotUnsubscribed();
        Logger().i('Subscribed to private channel: ${channel.name}');
      }
    });
  }

  void _subscribeToPresenceChannelsEvent({
    required PusherChannelsClient client,
    required List<Channel> channels,
  }) {
    client.onConnectionEstablished.listen((_) {
      for (final channel in channels) {
        channel.subscribeIfNotUnsubscribed();
        Logger().i('Subscribed to presence channel: ${channel.name}');
      }
    });
  }

  void _bindEventToPresenceChannel({
    required PresenceChannel channel,
    required String eventName,
  }) {
    // Handle data from the socket server here
    channel
      ..whenMemberAdded().listen((event) {
        Logger().i('Member added to the presence channel ${channel.name}!');
        Logger().e(event.data);
      })
      ..whenMemberRemoved().listen((event) {
        Logger().i('Member removed from the presence channel ${channel.name}!');
        Logger().e(event.data);
      })
      ..bind(eventName).listen((event) {
        Logger().i(
          '$eventName from the presence channel ${channel.name} fired!',
        );
        Logger().e(event.data);
      });
  }

  void _bindEventToChannel({
    required Channel channel,
    required String eventName,
  }) {
    // Handle data from the socket server here
    channel.bind(eventName).listen((event) {
      Logger().i('$eventName from the private channel ${channel.name} fired!');
      Logger().e(event.data);

      final data = json.decode(event.data as String) as Map<String, dynamic>;

      switch (FCEvent.fromIndex(data['event'] as int)) {
        case FCEvent.enquiryReplyCreated:
          Logger().f(data['data']);
        // final enquiryReplyData = FCEnquiryReply.fromJson(
        //   data['data'] as Map<String, dynamic>,
        // );

        // _isarService
        //     .persistEntity(enquiryReplyData)
        //     .then((_) {
        //       _isarService.enquiry.refreshParentStream(
        //         enquiryReplyData.enquiry!.ulid,
        //       );
        //     });
        case FCEvent.dailyWidgetAvailable:
          Logger().f('Daily widget available event received');

        case FCEvent.expireAllAccesses:
          Logger().f('Expire all accesses event received');
      }
    });
  }

  @override
  Future<void> init({required SocketConfig socketConfig}) async {
    final client = _initClient();

    final configuredChannels = <PrivateChannel>[];
    final configuredPresenceChannels = <PresenceChannel>[];

    socketConfig.privateChannels.forEach((channelName, events) {
      final privateChannel = _registerToPrivateChannel(
        client: client,
        channelName: channelName,
      );

      for (final eventName in events) {
        _bindEventToChannel(channel: privateChannel, eventName: eventName);
      }

      configuredChannels.add(privateChannel);
    });

    _subscribeToPrivateChannelsEvent(
      client: client,
      channels: configuredChannels,
    );

    socketConfig.presenceChannels?.forEach((channelName, events) {
      final presenceChannel = _registerToPresenceChannel(
        client: client,
        channelName: channelName,
      );

      for (final eventName in events) {
        _bindEventToPresenceChannel(
          channel: presenceChannel,
          eventName: eventName,
        );
      }

      configuredPresenceChannels.add(presenceChannel);
    });
    _subscribeToPresenceChannelsEvent(
      client: client,
      channels: configuredPresenceChannels,
    );

    await _connectClient(client: client);
  }

  @override
  SocketConfig defaultConfig() {
    final user = getIt<HiveService>().auth.retrieveProfile()!;
    // Register all channels and their events here
    // Assumption here is that there's only one channel for that user
    // Should more be needed, this function may need adjusting

    final privateChannels = <String, List<String>>{
      'App.Models.User.${user.ulid}': <String>[],
    };

    final presenceChannels = <String, List<String>>{};

    return SocketConfig(
      privateChannels: privateChannels,
      presenceChannels: presenceChannels,
    );
  }
}
