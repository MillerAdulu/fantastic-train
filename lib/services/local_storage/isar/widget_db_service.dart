import 'package:demo25/models/local/fc_widget.dart';
import 'package:demo25/models/remote/fc_widget.dart';
import 'package:demo25/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

class WidgetDbService extends BaseLocalDBService<FCWidget, FCLocalWidget> {
  WidgetDbService({required super.prfDBInstance});

  @override
  IsarCollection<FCLocalWidget> get collection => dbInstance.fCLocalWidgets;

  @override
  FCLocalWidget remoteToLocal(FCWidget remote) {
    return FCLocalWidget(
      ulid: remote.ulid,
      name: remote.name,
      uri: remote.uri,
      description: remote.description,
      createdAt: remote.createdAt,
      updatedAt: remote.updatedAt,
    );
  }

  @override
  Future<List<FCLocalWidget>> list({String? query}) async {
    return collection
        .where()
        .filter()
        .optional(
          query != null,
          (q) => q.nameContains(query!).descriptionContains(query),
        )
        .findAll();
  }

  Stream<List<FCLocalWidget>> filter({String? categoryUlid, String? query}) {
    return collection
        .where()
        .filter()
        .optional(
          query != null,
          (q) => q.nameContains(query!).descriptionContains(query),
        )
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }
}
