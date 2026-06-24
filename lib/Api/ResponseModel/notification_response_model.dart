import '../Utils/api_parser.dart';

class NotificationResponseModel {
  final String? status;
  final int? driverId;
  final List<NotificationItem>? notifications;
  final String? message;

  NotificationResponseModel({
    this.status,
    this.driverId,
    this.notifications,
    this.message,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      status: ApiParser.parseString(json['status']),
      driverId: ApiParser.parseInt(json['driver_id'] ?? json['customer_id']),
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
    data['driver_id'] = driverId;
    data['customer_id'] = driverId;
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
  final int? driverId;
  final String? driverName;

  NotificationItem({
    this.notificationId,
    this.title,
    this.message,
    this.notificationType,
    this.isRead,
    this.date,
    this.driverId,
    this.driverName,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: ApiParser.parseInt(json['notification_id']),
      title: ApiParser.parseString(json['title']),
      message: ApiParser.parseString(json['message']),
      notificationType: ApiParser.parseString(json['notification_type']),
      isRead: ApiParser.parseBool(json['is_read']),
      date: ApiParser.parseString(json['date']),
      driverId: ApiParser.parseInt(json['driver_id'] ?? json['customer_id']),
      driverName: ApiParser.parseString(json['driver_name'] ?? json['customer_name']),
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
    data['driver_id'] = driverId;
    data['customer_id'] = driverId;
    data['driver_name'] = driverName;
    data['customer_name'] = driverName;
    return data;
  }
}
