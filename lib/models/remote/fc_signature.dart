import 'package:freezed_annotation/freezed_annotation.dart';

part 'fc_signature.freezed.dart';
part 'fc_signature.g.dart';

@freezed
abstract class FCSignature with _$FCSignature {
  factory FCSignature(
    String ulid,
    String name,
    String uri,
    String description,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  ) = _FCSignature;

  factory FCSignature.fromJson(Map<String, dynamic> json) =>
      _$FCSignatureFromJson(json);
}
