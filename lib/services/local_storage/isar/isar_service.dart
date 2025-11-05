import 'package:demo25/models/local/fc_widget.dart';
import 'package:demo25/services/local_storage/isar/widget_db_service.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class IsarService {
  factory IsarService() => instance ??= IsarService._();
  IsarService._();

  static IsarService? instance;

  late final Isar prfDBInstance;

  late final WidgetDbService _widgets;
  WidgetDbService get widgets => _widgets;

  Future<void> initDatabase() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    final schemas = [
      FCLocalWidgetSchema,
    ];

    prfDBInstance = await Isar.open(schemas, directory: dir.path);

    _widgets = WidgetDbService(prfDBInstance: prfDBInstance);
  }

  Future<void> clearAllTables() async {
    await prfDBInstance.writeTxn(() async {
      await prfDBInstance.clear();
    });
  }
}
