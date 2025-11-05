import 'package:demo25/models/local/adapters.dart';
import 'package:demo25/services/local_storage/hive/auth_hive_service.dart';
import 'package:demo25/utils/constants.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveService {
  factory HiveService() => instance ??= HiveService._();
  HiveService._();

  static HiveService? instance;

  late final AuthHiveService _auth;

  AuthHiveService get auth => _auth;

  Future<void> initBoxes() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(FCUserAdapter());

    // Open boxes
    await Hive.openBox<dynamic>(FCConfig.instance!.values.hiveBox);
    await Hive.openBox<dynamic>(
      FCConfig.instance!.values.globalHiveAuthBox,
    );

    // Initialize services & sub-services
    _auth = AuthHiveService();
  }

  // Convenience methods that delegate to appropriate services
  void clearPrefs() {
    _auth.clearAuthData();
  }

  void clearBox() {
    _auth.clearAuthData();
  }
}
