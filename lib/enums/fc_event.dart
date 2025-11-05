import 'package:freezed_annotation/freezed_annotation.dart';

enum FCEvent {
  @JsonValue(1)
  enquiryReplyCreated,
  @JsonValue(2)
  dailyWidgetAvailable,
  @JsonValue(3)
  expireAllAccesses;

  String get name {
    switch (this) {
      case FCEvent.enquiryReplyCreated:
        return 'Enquiry Reply Created';
      case FCEvent.dailyWidgetAvailable:
        return 'Daily Widget Available';
      case FCEvent.expireAllAccesses:
        return 'Expire All Accesses';
    }
  }

  static FCEvent fromIndex(int index) {
    switch (index) {
      case 1:
        return FCEvent.enquiryReplyCreated;
      case 2:
        return FCEvent.dailyWidgetAvailable;
      case 3:
        return FCEvent.expireAllAccesses;
      default:
        return FCEvent.enquiryReplyCreated;
    }
  }
}
