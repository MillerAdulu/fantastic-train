import 'package:demo25/models/remote/fc_widget.dart';
import 'package:demo25/services/api/_base_api_service.dart';

class WidgetService extends BaseAPIService<FCWidget> {
  @override
  String get endpoint => '/widgets';

  @override
  FCWidget createFromJson(Map<String, dynamic> json) {
    return FCWidget.fromJson(json);
  }

  @override
  List<FCWidget> createListFromResponse(Map<String, dynamic> response) {
    return FCWidgetResponse.fromJson(response).data;
  }
}
