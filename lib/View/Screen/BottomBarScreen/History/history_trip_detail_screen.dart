import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:def_driver_system/View/Controller/trip_controller.dart';
import 'package:def_driver_system/View/Constant/app_color.dart';
import 'package:def_driver_system/Api/ResponseModel/trip_history_detail_response_model.dart';

class HistoryTripDetailScreen extends StatefulWidget {
  final int tripId;
  const HistoryTripDetailScreen({super.key, required this.tripId});

  @override
  State<HistoryTripDetailScreen> createState() => _HistoryTripDetailScreenState();
}

class _HistoryTripDetailScreenState extends State<HistoryTripDetailScreen> {
  final TripController _tripController = Get.find<TripController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tripController.fetchTripHistoryDetail(widget.tripId);
    });
  }

  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'HI',
      symbol: '₹',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return "N/A";
    try {
      final parsed = DateTime.parse(dateTimeStr);
      return DateFormat("hh:mm a").format(parsed);
    } catch (_) {
      return dateTimeStr;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Today";
    try {
      final parsed = DateTime.parse(dateStr);
      return DateFormat("MMMM d, yyyy").format(parsed);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Trip Detail History",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: GetBuilder<TripController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: appColor),
            );
          }

          final detail = controller.activeHistoryTripDetail;
          if (detail == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: greyTextColor),
                  const SizedBox(height: 16),
                  const Text(
                    "Details Not Available",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Unable to load this trip's details.",
                    style: TextStyle(color: greyTextColor),
                  ),
                ],
              ),
            );
          }

          final orders = detail.orders ?? [];

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Trip Header Metadata Card
                  Container(
                    decoration: _buildCardBoxDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              detail.tripName ?? "Trip #${detail.tripId}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0C243E),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xffE6F4EA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "COMPLETED",
                                style: TextStyle(
                                  color: greenColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildMetaRow(Icons.calendar_today_outlined, "Date", _formatDate(detail.tripDate)),
                        const SizedBox(height: 8),
                        _buildMetaRow(Icons.local_shipping_outlined, "Vehicle", detail.vehicleName ?? "N/A"),
                        const SizedBox(height: 8),
                        _buildMetaRow(Icons.person_outline, "Driver", detail.driverName ?? "N/A"),
                        const SizedBox(height: 8),
                        _buildMetaRow(Icons.factory_outlined, "Plant", detail.plantName ?? "N/A"),
                        const SizedBox(height: 8),
                        _buildMetaRow(Icons.route_outlined, "Route", detail.routeName ?? "N/A"),
                        const SizedBox(height: 8),
                        _buildMetaRow(
                          Icons.access_time_rounded,
                          "Duration",
                          "${_formatDateTime(detail.startTime)} - ${_formatDateTime(detail.endTime)}",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Statistics Summary Cards
                  Row(
                    children: [
                      _buildStatSummaryCard(
                        icon: Icons.inventory_2_outlined,
                        title: "Total Stops",
                        value: "${detail.totalOrders ?? orders.length}",
                        color: appColor,
                      ),
                      const SizedBox(width: 12),
                      _buildStatSummaryCard(
                        icon: Icons.scale_outlined,
                        title: "Total Weight",
                        value: "${detail.totalWeight?.toStringAsFixed(1) ?? '0'} kg",
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildStatSummaryCardFullWidth(
                    icon: Icons.currency_rupee_rounded,
                    title: "Total Earnings Collected",
                    value: _formatCurrency(detail.totalAmount ?? 0.0),
                    color: greenColor,
                  ),
                  const SizedBox(height: 24),

                  // 3. Orders Header
                  Text(
                    "Order List (${orders.length})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0C243E),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 4. List of Orders
                  if (orders.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          "No orders in this trip.",
                          style: TextStyle(color: greyTextColor),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _buildOrderCard(order);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetaRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Color(0xff0C243E), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildStatSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        decoration: _buildCardBoxDecoration(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: greyTextColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatSummaryCardFullWidth({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: _buildCardBoxDecoration(),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: greyTextColor, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(HistoryOrder order) {
    final bool isDelivered = order.state?.toLowerCase() == 'delivered' || order.state?.toLowerCase() == 'done';
    final Color stateColor = isDelivered ? greenColor : orangeColor;
    final Color stateBg = isDelivered ? const Color(0xffE6F4EA) : Colors.orange.shade50;

    return Container(
      decoration: _buildCardBoxDecoration(),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Order Name, Status Badge, Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderName ?? "Order #${order.orderId}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0C243E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: stateBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (order.state ?? "Pending").toUpperCase(),
                  style: TextStyle(
                    color: stateColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Customer Name
          Text(
            order.customerName?.isNotEmpty == true ? order.customerName! : "Unknown Customer",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xff0C243E),
            ),
          ),
          const SizedBox(height: 4),

          // Phone Number with tap-to-copy
          if (order.mobile != null && order.mobile!.isNotEmpty)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: order.mobile!));
                Get.snackbar(
                  "Copied",
                  "Phone number copied to clipboard.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xff0C243E),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.phone_android_rounded, size: 14, color: greyTextColor),
                  const SizedBox(width: 4),
                  Text(
                    order.mobile!,
                    style: const TextStyle(fontSize: 12, color: appColor, decoration: TextDecoration.underline),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.copy_rounded, size: 12, color: Colors.grey.shade400),
                ],
              ),
            ),
          const SizedBox(height: 8),

          // Divider
          const Divider(),
          const SizedBox(height: 8),

          // Row 3: Amount & Delivery Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Amount Collected", style: TextStyle(fontSize: 10, color: greyTextColor)),
                  const SizedBox(height: 2),
                  Text(
                    _formatCurrency(order.amountTotal ?? 0.0),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
                  ),
                ],
              ),
              if (order.deliveryDate != null && order.deliveryDate!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Delivery Timestamp", style: TextStyle(fontSize: 10, color: greyTextColor)),
                    const SizedBox(height: 2),
                    Text(
                      "${_formatDate(order.deliveryDate)} ${_formatDateTime(order.deliveryDate)}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff0C243E)),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 4: Verification Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildVerificationIndicator(
                icon: Icons.vpn_key_outlined,
                label: "OTP Verified",
                isValid: order.otpVerified ?? false,
              ),
              _buildVerificationIndicator(
                icon: Icons.draw_outlined,
                label: "Signature",
                isValid: order.signatureUploaded ?? false,
              ),
              _buildVerificationIndicator(
                icon: Icons.camera_alt_outlined,
                label: "POD Photo",
                isValid: order.podUploaded ?? false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationIndicator({
    required IconData icon,
    required String label,
    required bool isValid,
  }) {
    final Color color = isValid ? greenColor : Colors.grey;
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: color, fontWeight: isValid ? FontWeight.bold : FontWeight.normal),
        ),
        const SizedBox(width: 4),
        Icon(
          isValid ? Icons.check_circle : Icons.cancel_outlined,
          size: 12,
          color: color,
        ),
      ],
    );
  }

  BoxDecoration _buildCardBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
