import 'package:demo25/models/remote/auth.dart';
import 'package:demo25/services/local_storage/hive/_base_hive_service.dart';
import 'package:demo25/utils/constants.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class AuthHiveService extends BaseHiveService {
  @override
  String get boxName => FCConfig.instance!.values.hiveBox;

  // Token management
  void persistToken(String token) {
    putWithExpiry('accessToken', token, const Duration(days: 3));

    // Update logout status in global box
    Hive.box<dynamic>(
      FCConfig.instance!.values.globalHiveAuthBox,
    ).put('isLoggedOut', false);
  }

  String? retrieveToken() {
    final token = getWithExpiry<String>('accessToken');
    if (token == null) {
      Hive.box<dynamic>(
        FCConfig.instance!.values.globalHiveAuthBox,
      ).put('isLoggedOut', true);
    }
    return token;
  }

  bool isLoggedOut() {
    return Hive.box<dynamic>(
              FCConfig.instance!.values.globalHiveAuthBox,
            ).get('isLoggedOut')
            as bool? ??
        false;
  }

  // Profile management
  void persistProfile(FCUser profile) {
    Logger().i('Persisting profile: $profile');
    put('profile', profile);
  }

  FCUser? retrieveProfile() {
    return get<FCUser>('profile');
  }

  String get timezone => retrieveProfile()!.timezone;

  void persistCredentials({required String email}) {
    Hive.box<dynamic>(
      FCConfig.instance!.values.hiveBox,
    ).put('credentials', [email]);
  }

  String retrieveCredentials() {
    final box = Hive.box<dynamic>(FCConfig.instance!.values.hiveBox);
    final credentials = box.get('credentials') as List<dynamic>?;
    if (credentials == null) return '';
    return (credentials[0] as String).replaceAll('@fluttercondev.ke', '');
  }

  // Clear auth data
  void clearAuthData() {
    deleteAll(['accessToken', 'accessToken_expiry', 'profile']);
  }
}
