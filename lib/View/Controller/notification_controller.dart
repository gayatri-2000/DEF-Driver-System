import 'dart:developer';
import 'package:get/get.dart';
import '../../Api/Repo/notification_repo.dart';
import '../../Api/ResponseModel/notification_response_model.dart';
import '../../View/Constant/shared_prefs.dart';

class NotificationController extends GetxController {
  final NotificationRepo _notificationRepo = NotificationRepo();
  
  List<NotificationItem> notifications = [];
  bool isLoading = false;

  bool get hasUnread => notifications.any((n) => n.isRead == false);

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading = true;
    update();

    try {
      await preferences.init();
      final String uidStr = preferences.getString(SharedPreference.userId) ?? "";
      if (uidStr.isNotEmpty) {
        final int customerId = int.tryParse(uidStr) ?? 0;
        log("NotificationController: Fetching notifications for customer ID: $customerId");
        final NotificationResponseModel res = await _notificationRepo.getNotifications(customerId);
        if (res.status == "SUCCESS") {
          notifications = res.notifications ?? [];
          log("NotificationController: Loaded ${notifications.length} notifications.");
        } else {
          log("NotificationController Error: ${res.message}");
        }
      } else {
        log("NotificationController: No logged-in user ID found in preferences.");
      }
    } catch (e) {
      log("NotificationController Error fetching: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      final item = notifications[i];
      if (item.isRead == false) {
        notifications[i] = NotificationItem(
          notificationId: item.notificationId,
          title: item.title,
          message: item.message,
          notificationType: item.notificationType,
          isRead: true,
          date: item.date,
          customerId: item.customerId,
          customerName: item.customerName,
        );
      }
    }
    update();
  }

  void markAsRead(int notificationId) {
    final index = notifications.indexWhere((n) => n.notificationId == notificationId);
    if (index != -1) {
      final item = notifications[index];
      if (item.isRead == false) {
        notifications[index] = NotificationItem(
          notificationId: item.notificationId,
          title: item.title,
          message: item.message,
          notificationType: item.notificationType,
          isRead: true,
          date: item.date,
          customerId: item.customerId,
          customerName: item.customerName,
        );
        update();
      }
    }
  }

  void clearAll() {
    notifications.clear();
    update();
  }
}
