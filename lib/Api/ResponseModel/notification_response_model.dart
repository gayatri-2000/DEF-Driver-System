import '../Utils/api_parser.dart';

class NotificationResponseModel {
  final String? status;
  final int? customerId;
  final List<NotificationItem>? notifications;
  final String? message;

  NotificationResponseModel({
    this.status,
    this.customerId,
    this.notifications,
    this.message,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      status: ApiParser.parseString(json['status']),
      customerId: ApiParser.parseInt(json['customer_id']),
      notifications: json['notifications'] != null
          ? (json['notifications'] as List)
              .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      message: ApiParser.parseString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['customer_id'] = customerId;
    if (notifications != null) {
      data['notifications'] = notifications!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class NotificationItem {
  final int? notificationId;
  final String? title;
  final String? message;
  final String? notificationType;
  final bool? isRead;
  final String? date;
  final int? customerId;
  final String? customerName;

  NotificationItem({
    this.notificationId,
    this.title,
    this.message,
    this.notificationType,
    this.isRead,
    this.date,
    this.customerId,
    this.customerName,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: ApiParser.parseInt(json['notification_id']),
      title: ApiParser.parseString(json['title']),
      message: ApiParser.parseString(json['message']),
      notificationType: ApiParser.parseString(json['notification_type']),
      isRead: ApiParser.parseBool(json['is_read']),
      date: ApiParser.parseString(json['date']),
      customerId: ApiParser.parseInt(json['customer_id']),
      customerName: ApiParser.parseString(json['customer_name']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_id'] = notificationId;
    data['title'] = title;
    data['message'] = message;
    data['notification_type'] = notificationType;
    data['is_read'] = isRead;
    data['date'] = date;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    return data;
  }
}
