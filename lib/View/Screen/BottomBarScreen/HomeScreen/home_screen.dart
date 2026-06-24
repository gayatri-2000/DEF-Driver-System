import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:def_driver_system/View/Controller/trip_controller.dart';
import 'package:def_driver_system/View/Constant/app_color.dart';
import 'package:def_driver_system/Api/Repo/mock_data.dart';
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Trips",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GetBuilder<TripController>(
              builder: (controller) {
                String dateStr = DateFormat("MMMM d, yyyy").format(DateTime.now());
                final tripDate = controller.activeTrip?.date;
                if (tripDate != null && tripDate != "Today") {
                  try {
                    // Try parsing "YYYY-MM-DD" style date
                    final parsed = DateTime.parse(tripDate);
                    dateStr = DateFormat("MMMM d, yyyy").format(parsed);
                  } catch (_) {
                    dateStr = tripDate;
                  }
                }
                return Text(
                  dateStr,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                );
              },
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

          final assignedTrips = [
            ...controller.inTransitTrips,
            ...controller.pendingTrips,
          ];
          final completedTrips = controller.completedTripsList;

          final showList = controller.selectedTripTab == 0 ? assignedTrips : completedTrips;

          return RefreshIndicator(
            onRefresh: () => controller.loadTrips(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (controller.isOffline) _buildOfflineBanner(),
                    
                    // 1. Grid of 4 metrics cards
                    Row(
                      children: [
                        _buildMetricCard(
                          icon: Icons.inventory_2_outlined,
                          value: (controller.statistics?.totalOrders ?? 0).toString(),
                          label: "Total Orders",
                          color: appColor,
                        ),
                        const SizedBox(width: 12),
                        _buildMetricCard(
                          icon: Icons.check_circle_outline,
                          value: (controller.statistics?.deliveredOrders ?? 0).toString(),
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
                          value: (controller.statistics?.inTransitOrders ?? 0).toString(),
                          label: "In Transit",
                          color: orangeColor,
                        ),
                        const SizedBox(width: 12),
                        _buildMetricCard(
                          icon: Icons.assignment_turned_in_outlined,
                          value: (controller.statistics?.dispatchedOrders ?? 0).toString(),
                          label: "Dispatched",
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 2. Custom Tabs Toggle
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.changeTripTab(0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: controller.selectedTripTab == 0 ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: controller.selectedTripTab == 0
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    "Assigned (${assignedTrips.length})",
                                    style: TextStyle(
                                      color: controller.selectedTripTab == 0 ? const Color(0xff0C243E) : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.changeTripTab(1);
                                controller.fetchHistoryTrips();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: controller.selectedTripTab == 1 ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: controller.selectedTripTab == 1
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    "Completed (${completedTrips.length})",
                                    style: TextStyle(
                                      color: controller.selectedTripTab == 1 ? const Color(0xff0C243E) : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. Trips List
                    if (showList.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Column(
                            children: [
                              Icon(Icons.local_shipping_outlined, size: 48, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text(
                                controller.selectedTripTab == 0 ? "No Assigned Trips" : "No Completed Trips",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.selectedTripTab == 0
                                    ? "Any new routes assigned will appear here."
                                    : "Completed route sheets will display here.",
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: showList.length,
                        itemBuilder: (context, index) {
                          final trip = showList[index];
                          return _buildTripCard(context, trip, controller);
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
              color: color.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
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

  Widget _buildTripCard(BuildContext context, Trip trip, TripController controller) {
    final bool isPending = trip.status == "Pending";
    final bool isInTransit = trip.status == "In Progress";
    final bool isCompleted = trip.status == "Done";

    Color badgeBg = Colors.grey.shade100;
    Color badgeText = Colors.grey.shade600;
    if (isInTransit) {
      badgeBg = appColor.withOpacity(0.1);
      badgeText = appColor;
    } else if (isCompleted) {
      badgeBg = const Color(0xffE6F4EA);
      badgeText = greenColor;
    } else if (isPending) {
      badgeBg = Colors.amber.shade50;
      badgeText = Colors.amber.shade800;
    }

    // Decode Route or Vehicle reg cleanly
    final parts = trip.vehicleReg.split('|');
    final String routeName = parts.isNotEmpty ? parts[0] : trip.vehicleReg;

    return Container(
      decoration: _buildCardBoxDecoration(),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trip.id,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0C243E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trip.status.toUpperCase(),
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.route_outlined, size: 16, color: greyTextColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Route: $routeName",
                  style: TextStyle(fontSize: 13, color: greyTextColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: greyTextColor),
              const SizedBox(width: 8),
              Text(
                trip.date,
                style: TextStyle(fontSize: 13, color: greyTextColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Stops", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(
                    "${trip.stopsCount} Stops",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0C243E),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Total Revenue", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(
                    _formatCurrency(trip.totalAmount),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: appColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isPending)
            ElevatedButton(
              onPressed: () => controller.startTrip(trip.dbTripId ?? 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: greenColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Start Trip",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (isInTransit)
            ElevatedButton(
              onPressed: () => controller.selectTripAndGo(trip.dbTripId ?? 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.navigation_outlined, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    "Resume / View Stops",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
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
                  Icon(Icons.check_circle_outline, color: greenColor, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "Trip Completed Successfully",
                    style: TextStyle(
                      color: greenColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.amber.shade800),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Offline Mode",
                  style: TextStyle(
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Displaying locally cached route details.",
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontSize: 12,
                  ),
                ),
              ],
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
