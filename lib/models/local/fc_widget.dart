import 'package:isar_community/isar.dart';

part 'fc_widget.g.dart';

@collection
class FCLocalWidget {
  FCLocalWidget({
    required this.ulid,
    required this.name,
    required this.uri,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String ulid;

  @Index(unique: true, replace: true)
  final String name;

  @Index(unique: true, replace: true)
  final String uri;
  final String description;

  final DateTime createdAt;
  final DateTime updatedAt;
}
