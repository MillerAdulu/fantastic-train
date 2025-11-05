import 'package:freezed_annotation/freezed_annotation.dart';

part 'fc_attribute.freezed.dart';
part 'fc_attribute.g.dart';

@freezed
abstract class FCAttribute with _$FCAttribute {
  factory FCAttribute(
    String ulid,
    String name,
    String uri,
    String description,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  ) = _FCAttribute;

  factory FCAttribute.fromJson(Map<String, dynamic> json) =>
      _$FCAttributeFromJson(json);
}
