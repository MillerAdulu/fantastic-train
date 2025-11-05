import 'package:demo25/models/remote/fc_property.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fc_widget.freezed.dart';
part 'fc_widget.g.dart';

@freezed
abstract class FCWidget with _$FCWidget {
  factory FCWidget(
    String ulid,
    String name,
    String uri,
    String description,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @Default([]) List<FCProperty> properties,
  }) = _FCWidget;

  factory FCWidget.fromJson(Map<String, dynamic> json) =>
      _$FCWidgetFromJson(json);
}

@freezed
abstract class FCWidgetResponse with _$FCWidgetResponse {
  const factory FCWidgetResponse({required List<FCWidget> data}) =
      _FCWidgetResponse;

  factory FCWidgetResponse.fromJson(Map<String, dynamic> json) =>
      _$FCWidgetResponseFromJson(json);
}
