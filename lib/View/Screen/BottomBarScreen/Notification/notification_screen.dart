import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Api/ResponseModel/notification_response_model.dart';
import '../../../../View/Controller/notification_controller.dart';
import '../../../Constant/app_color.dart';
import '../../../Utils/app_layout.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController _notificationController = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationController.fetchNotifications();
    });
  }

  Map<String, dynamic> _getIconDetails(String? notificationType) {
    final type = (notificationType ?? "").toLowerCase();
    if (type == "route" || type == "trip") {
      return {
        "icon": Icons.local_shipping_outlined,
        "iconBg": appColor.withOpacity(0.1),
        "iconColor": appColor,
      };
    } else if (type == "alert" || type == "warning") {
      return {
        "icon": Icons.warning_amber_rounded,
        "iconBg": orangeColor.withOpacity(0.1),
        "iconColor": orangeColor,
      };
    } else if (type == "stock" || type == "load") {
      return {
        "icon": Icons.inventory_2_outlined,
        "iconBg": greenColor.withOpacity(0.1),
        "iconColor": greenColor,
      };
    } else if (type == "invoice") {
      return {
        "icon": Icons.receipt_long_outlined,
        "iconBg": Colors.blue.shade50,
        "iconColor": Colors.blue,
      };
    } else if (type == "incentive" || type == "wallet" || type == "payment") {
      return {
        "icon": Icons.account_balance_wallet_outlined,
        "iconBg": greenColor.withOpacity(0.1),
        "iconColor": greenColor,
      };
    } else {
      return {
        "icon": Icons.notifications_none_rounded,
        "iconBg": appColor.withOpacity(0.1),
        "iconColor": appColor,
      };
    }
  }

  void _markAllAsRead() {
    _notificationController.markAllAsRead();
    successSnackBar(
      "Notifications",
      "All notifications marked as read.",
    );
  }

  void _clearAll() {
    _notificationController.clearAll();
    successSnackBar(
      "Notifications",
      "All notifications cleared.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        final notificationsList = controller.notifications;
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: appColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "Notifications",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: notificationsList.isNotEmpty
                ? [
                    TextButton(
                      onPressed: _markAllAsRead,
                      child: const Text(
                        "Read All",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
                      onPressed: _clearAll,
                    ),
                    const SizedBox(width: 8),
                  ]
                : null,
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.fetchNotifications(),
            child: controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: appColor),
                  )
                : notificationsList.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.notifications_off_outlined,
                                    size: 64, color: greyTextColor.withOpacity(0.5)),
                                const SizedBox(height: 16),
                                const Text(
                                  "All caught up!",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0C243E)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "You will receive alerts here for new routes & loads.",
                                  style: TextStyle(color: greyTextColor, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: notificationsList.length,
                        itemBuilder: (context, index) {
                          final notification = notificationsList[index];
                          return _buildNotificationCard(notification, controller);
                        },
                      ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, NotificationController controller) {
    final bool isRead = notification.isRead ?? false;
    final iconDetails = _getIconDetails(notification.notificationType);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xffF0F6FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: isRead
            ? Border.all(color: Colors.grey.shade200, width: 0.5)
            : Border.all(color: appColor.withOpacity(0.2), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconDetails["iconBg"] as Color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            iconDetails["icon"] as IconData,
            color: iconDetails["iconColor"] as Color,
            size: 20,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                notification.title ?? "Alert",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isRead ? FontWeight.bold : FontWeight.w800,
                  color: const Color(0xff0C243E),
                ),
              ),
            ),
            Text(
              notification.date ?? "",
              style: TextStyle(
                fontSize: 11,
                color: greyTextColor,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            notification.message ?? "",
            style: TextStyle(
              fontSize: 12,
              color: isRead ? greyTextColor : Colors.black87,
              height: 1.3,
            ),
          ),
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: appColor,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          if (notification.notificationId != null) {
            controller.markAsRead(notification.notificationId!);
          }
        },
      ),
    );
  }
}
