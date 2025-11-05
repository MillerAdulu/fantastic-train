import 'dart:async';
import 'dart:developer';


import 'package:bloc/bloc.dart';
import 'package:demo25/models/remote/socket_config.dart';
import 'package:demo25/services/local_storage/hive/hive_service.dart';
import 'package:demo25/services/socket_service.dart';
import 'package:demo25/utils/singletons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/google_fonts/OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  Singletons.setup();
  await Singletons.setupDatabases();

  final userUlid = getIt<HiveService>().auth.retrieveProfile()?.ulid;

    if (userUlid != null) {
      final defaultConfig = getIt<SocketService>().defaultConfig();

      try {
        await getIt<SocketService>().init(
          socketConfig: SocketConfig(
            privateChannels: defaultConfig.privateChannels,
            presenceChannels: defaultConfig.presenceChannels,
          ),
        );
      } catch (e) {
        Logger().e('SocketService init error: $e');
      }

    }

  runApp(await builder());
}
