import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:def_driver_system/View/Controller/trip_controller.dart';
import 'package:def_driver_system/View/Constant/app_color.dart';
import 'package:def_driver_system/Api/Repo/mock_data.dart';
import 'package:def_driver_system/View/Screen/Delivery/delivery_verification_screen.dart';
import 'route_navigation_screen.dart';
import 'package:def_driver_system/View/Screen/BottomBarScreen/Notification/notification_screen.dart';
import 'package:def_driver_system/View/Controller/notification_controller.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate or retrieve our controller
    Get.put(TripController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Trips",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "May 25, 2026",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          // Notification Bell with Badge
          GetBuilder<NotificationController>(
            builder: (notiController) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 26),
                    onPressed: () {
                      Get.to(() => const NotificationScreen());
                    },
                  ),
                  if (notiController.hasUnread)
                    Positioned(
                      top: 10,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: false,
      ),
      body: GetBuilder<TripController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: appColor),
            );
          }

          final trip = controller.activeTrip;

          if (trip == null) {
            return RefreshIndicator(
              onRefresh: () => controller.loadTrips(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            size: 64, color: greyTextColor),
                        const SizedBox(height: 16),
                        const Text(
                          "No Active Orders",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0C243E)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "You have completed all trips for today.",
                          style: TextStyle(color: greyTextColor),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.loadTrips(),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: appColor),
                          child: const Text("Reload Dashboard",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadTrips(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Grid of 4 colorful metrics cards
                    Row(
                      children: [
                        _buildMetricCard(
                          icon: Icons.inventory_2_outlined,
                          value: (controller.statistics?.totalOrders ??
                                  trip.stopsCount)
                              .toString(),
                          label: "Total Orders",
                          color: appColor,
                        ),
                        const SizedBox(width: 12),
                        _buildMetricCard(
                          icon: Icons.check_circle_outline,
                          value: (controller.statistics?.deliveredOrders ??
                                  trip.doneCount)
                              .toString(),
                          label: "Delivered",
                          color: greenColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildMetricCard(
                          icon: Icons.local_shipping_outlined,
                          value: (controller.statistics?.inTransitOrders ?? 0)
                              .toString(),
                          label: "In Transit",
                          color: orangeColor,
                        ),
                        const SizedBox(width: 12),
                        _buildMetricCard(
                          icon: Icons.assignment_turned_in_outlined,
                          value: (controller.statistics?.dispatchedOrders ?? 0)
                              .toString(),
                          label: "Dispatched",
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 2. Active Trip Info Card
                    Container(
                      decoration: _buildCardBoxDecoration(),
                      padding: const EdgeInsets.all(16),
                      child: Builder(builder: (context) {
                        final parts = trip.vehicleReg.split('|');
                        final String vehicleName =
                            parts.isNotEmpty ? parts[0] : trip.vehicleReg;
                        final String rawState =
                            parts.length > 1 ? parts[1] : "in_transit";
                        final int tripId = parts.length > 2
                            ? (int.tryParse(parts[2]) ?? 1)
                            : 1;
                        final bool canStart =
                            rawState == "draft" || rawState == "confirmed";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Active Route Info",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0C243E),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: canStart
                                        ? Colors.amber.shade50
                                        : const Color(0xffE6F4EA),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    rawState.toUpperCase(),
                                    style: TextStyle(
                                      color: canStart
                                          ? Colors.amber.shade800
                                          : greenColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Vehicle ID: $vehicleName",
                              style:
                                  TextStyle(fontSize: 12, color: greyTextColor),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.payment_outlined,
                                    size: 16, color: greyTextColor),
                                const SizedBox(width: 6),
                                Text(
                                  "Total Registered Revenue: ${_formatCurrency(trip.totalAmount)}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: greyTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (canStart) {
                                  controller.startTrip(tripId);
                                } else {
                                  Get.to(() => const RouteNavigationScreen());
                                }
                              },
                              icon: Icon(
                                canStart
                                    ? Icons.play_arrow_rounded
                                    : Icons.navigation_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: Text(
                                canStart
                                    ? "Start Trip"
                                    : "Start Navigation Map",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    canStart ? greenColor : appColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    // 3. Delivery Stops Section Header
                    const Text(
                      "Current Delivery Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0C243E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. Stop Cards List (Filter out Chennai Plant at index 0)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: trip.stops.length - 1,
                      itemBuilder: (context, index) {
                        // index corresponds to stopIndex - 1 because we skipped stop 0 (Chennai Plant)
                        final stop = trip.stops[index + 1];
                        return _buildStopCard(context, stop);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatCurrency(double amount) {
    return "₹${amount.toStringAsFixed(0)}";
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStopCard(BuildContext context, RouteStop stop) {
    bool isCompleted = stop.status == "Delivered";
    bool isInProgress = stop.status == "Active";
    bool isPending = stop.status == "Upcoming";

    // Circular badge styling
    Color badgeBg = Colors.grey.shade100;
    Color badgeText = Colors.grey.shade600;
    Color statusBg = Colors.grey.shade100;
    Color statusText = Colors.grey;
    String statusLabel = "Pending";

    if (isCompleted) {
      badgeBg = const Color(0xffE6F4EA);
      badgeText = greenColor;
      statusBg = const Color(0xffE6F4EA);
      statusText = greenColor;
      statusLabel = "Completed";
    } else if (isInProgress) {
      badgeBg = appColor.withOpacity(0.1);
      badgeText = appColor;
      statusBg = appColor.withOpacity(0.1);
      statusText = appColor;
      statusLabel = "In Progress";
    }

    // Prepare Quantity string
    String qtyString = "";
    if (stop.barrelsQty > 0 && stop.cansQty > 0) {
      qtyString = "${stop.barrelsQty} Barrels + ${stop.cansQty} Cans";
    } else if (stop.barrelsQty > 0) {
      qtyString = "${stop.barrelsQty} Barrels";
    } else if (stop.cansQty > 0) {
      qtyString = "${stop.cansQty} Cans";
    } else {
      qtyString = "0 Items";
    }

    return Container(
      decoration: _buildCardBoxDecoration(),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Stop Number Badge, Pump Name, Status Badge
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: badgeBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stop.index.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: badgeText,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  stop.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0C243E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusText,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Address info
          Text(
            stop.address,
            style: TextStyle(fontSize: 12, color: greyTextColor),
          ),
          const SizedBox(height: 10),

          // Time range info
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: greyTextColor),
              const SizedBox(width: 6),
              Text(
                stop.timeRange,
                style: TextStyle(
                    fontSize: 12,
                    color: greyTextColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Quantity Block
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: textFieldColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quantity",
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  qtyString,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0C243E)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Bottom Action Button
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xffE6F4EA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: greenColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, color: greenColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Delivered Successfully",
                    style: TextStyle(
                      color: greenColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          if (isInProgress)
            ElevatedButton(
              onPressed: () {
                Get.to(() => DeliveryVerificationScreen(
                      stopIndex: stop.index,
                      pumpName: stop.name,
                      barrelsQty: stop.barrelsQty,
                      cansQty: stop.cansQty,
                      expectedOtp: stop.otpCode,
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Complete Delivery",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (isPending)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Waiting",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
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
