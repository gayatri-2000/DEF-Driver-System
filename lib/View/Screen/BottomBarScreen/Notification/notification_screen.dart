import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constant/app_color.dart';
import '../../../Utils/app_layout.dart';

class MockNotification {
  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  bool isRead;

  MockNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Pre-loaded realistic operational notifications based on driver workflow
  final List<MockNotification> _notifications = [
    MockNotification(
      id: "1",
      title: "New Route Assigned",
      description: "Trip TRIP001 (8 stops) has been assigned to your vehicle TN 01 AB 1234 by Chennai Plant Manager.",
      time: "5 mins ago",
      icon: Icons.local_shipping_outlined,
      iconBg: appColor.withOpacity(0.1),
      iconColor: appColor,
      isRead: false,
    ),
    MockNotification(
      id: "2",
      title: "Traffic Alert & Detour",
      description: "Logistics Alert: NH-48 has heavy traffic. Google Maps optimized route to Essar Porur via bypass road.",
      time: "45 mins ago",
      icon: Icons.warning_amber_rounded,
      iconBg: orangeColor.withOpacity(0.1),
      iconColor: orangeColor,
      isRead: false,
    ),
    MockNotification(
      id: "3",
      title: "Stock Loaded Confirmed",
      description: "Chennai Factory confirmed loading of 100 Barrels + 40 Cans onto your tanker. Gate-pass issued.",
      time: "1 hour ago",
      icon: Icons.inventory_2_outlined,
      iconBg: greenColor.withOpacity(0.1),
      iconColor: greenColor,
      isRead: true,
    ),
    MockNotification(
      id: "4",
      title: "Invoice Generated",
      description: "GST Invoice #INV-9282 generated for HP Petrol Station - T Nagar: ₹37,500. Accounts updated.",
      time: "Yesterday",
      icon: Icons.receipt_long_outlined,
      iconBg: Colors.blue.shade50,
      iconColor: Colors.blue,
      isRead: true,
    ),
    MockNotification(
      id: "5",
      title: "Trip Incentive Credited",
      description: "Congratulations! An incentive of ₹500 has been credited to your driver wallet for completing TRIP098 on-time.",
      time: "2 days ago",
      icon: Icons.account_balance_wallet_outlined,
      iconBg: greenColor.withOpacity(0.1),
      iconColor: greenColor,
      isRead: true,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    successSnackBar(
      "Notifications",
      "All notifications marked as read.",
    );
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
    successSnackBar(
      "Notifications",
      "All notifications cleared.",
    );
  }

  @override
  Widget build(BuildContext context) {
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
        actions: _notifications.isNotEmpty
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
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: greyTextColor.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    "All caught up!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You will receive alerts here for new routes & loads.",
                    style: TextStyle(color: greyTextColor, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
    );
  }

  Widget _buildNotificationCard(MockNotification notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : const Color(0xffF0F6FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: notification.isRead
            ? Border.all(color: Colors.grey.shade200, width: 0.5)
            : Border.all(color: appColor.withOpacity(0.2), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: notification.iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(notification.icon, color: notification.iconColor, size: 20),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: notification.isRead ? FontWeight.bold : FontWeight.w800,
                  color: const Color(0xff0C243E),
                ),
              ),
            ),
            Text(
              notification.time,
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
            notification.description,
            style: TextStyle(
              fontSize: 12,
              color: notification.isRead ? greyTextColor : Colors.black87,
              height: 1.3,
            ),
          ),
        ),
        trailing: !notification.isRead
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
          setState(() {
            notification.isRead = true;
          });
        },
      ),
    );
  }
}
