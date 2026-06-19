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
      status: json['status'] as String?,
      customerId: json['customer_id'] as int?,
      notifications: json['notifications'] != null
          ? (json['notifications'] as List)
              .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      message: json['message'] as String?,
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
      notificationId: json['notification_id'] as int?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      notificationType: json['notification_type'] as String?,
      isRead: json['is_read'] as bool?,
      date: json['date'] as String?,
      customerId: json['customer_id'] as int?,
      customerName: json['customer_name'] as String?,
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
