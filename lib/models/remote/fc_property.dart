import 'package:demo25/models/remote/fc_attribute.dart';
import 'package:demo25/models/remote/fc_signature.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fc_property.freezed.dart';
part 'fc_property.g.dart';

@freezed
abstract class FCProperty with _$FCProperty {
  factory FCProperty(
    String ulid,
    @JsonKey(name: 'attribute_label') String attributeLabel,
    @JsonKey(name: 'attribute_uri') String attributeUri,
    @JsonKey(name: 'signature_label') String signatureLabel, {
    @JsonKey(name: 'signature_uri') String? signatureUri,
    String? description,
    FCSignature? signature,
    FCAttribute? attribute,
  }) = _FCProperty;

  factory FCProperty.fromJson(Map<String, dynamic> json) =>
      _$FCPropertyFromJson(json);
}
