import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:def_driver_system/View/Controller/trip_controller.dart';
import 'package:def_driver_system/View/Constant/app_color.dart';
import 'package:def_driver_system/Api/Repo/mock_data.dart';
import 'package:def_driver_system/View/Screen/BottomBarScreen/HomeScreen/route_navigation_screen.dart';
import 'history_trip_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TripController _tripController = Get.find<TripController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tripController.fetchHistoryTrips();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'HI',
      symbol: '₹',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delivery History",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Text(
              "Past deliveries and trips",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _tripController.fetchHistoryTrips(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      _tripController.searchHistoryTrips(val);
                    },
                    decoration: InputDecoration(
                      hintText: "Search by trip ID or date...",
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Monthly Performance Card
                GetBuilder<TripController>(
                  builder: (controller) {
                    final int totalTrips = controller.completedTripsList.length;
                    final int totalDeliveries = controller.completedTripsList.fold<int>(
                      0,
                      (sum, trip) => sum + trip.stopsCount,
                    );
                    final String onTimeRate = totalTrips == 0 ? "100%" : "98%";

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: appColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: appColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "This Month's Performance",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPerformanceStat(totalTrips.toString(), "Trips"),
                              _buildPerformanceStat(totalDeliveries.toString(), "Deliveries"),
                              _buildPerformanceStat(onTimeRate, "On-Time"),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Grouped History List
                GetBuilder<TripController>(
                  builder: (controller) {
                    if (controller.isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: CircularProgressIndicator(color: appColor),
                        ),
                      );
                    }

                    if (controller.completedTripsFiltered.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Column(
                            children: [
                              Icon(Icons.search_off_outlined,
                                  size: 48, color: greyTextColor),
                              const SizedBox(height: 12),
                              Text(
                                "No matching trips found",
                                style: TextStyle(
                                    color: greyTextColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Group by Date in UI (since it's mock, we map by date groups)
                    // Grouping trips by date
                    Map<String, List<Trip>> groupedTrips = {};
                    for (var trip in controller.completedTripsFiltered) {
                      if (!groupedTrips.containsKey(trip.date)) {
                        groupedTrips[trip.date] = [];
                      }
                      groupedTrips[trip.date]!.add(trip);
                    }

                    List<Widget> groupedViews = [];
                    groupedTrips.forEach((date, tripList) {
                      groupedViews.add(
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: greyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      for (var trip in tripList) {
                        groupedViews.add(
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildTripCard(trip),
                          ),
                        );
                      }
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: groupedViews,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceStat(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard(Trip trip) {
    bool isInProgress = trip.status == "In Transit";
    Color progressColor = isInProgress ? appColor : greenColor;
    Color statusBg =
        isInProgress ? appColor.withOpacity(0.1) : const Color(0xffE6F4EA);
    Color statusText = isInProgress ? appColor : greenColor;

    return GestureDetector(
      onTap: () {
        if (isInProgress) {
          Get.to(() => const RouteNavigationScreen());
        } else {
          int parsedId = trip.dbTripId ?? 1;
          if (trip.dbTripId == null) {
            final cleanedId = trip.id
                .replaceAll('TS-0', '')
                .replaceAll('TS/', '')
                .replaceAll('TRIP', '');
            parsedId = int.tryParse(cleanedId) ?? 1;
          }
          Get.to(() => HistoryTripDetailScreen(tripId: parsedId));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Trip Name, Status Badge, Val Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trip ${trip.id}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0C243E),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trip.status,
                    style: TextStyle(
                      color: statusText,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _formatCurrency(trip.totalAmount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0C243E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Row 2: Ratio of Deliveries done
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${trip.doneCount}/${trip.stopsCount} deliveries",
                  style: TextStyle(
                    fontSize: 12,
                    color: greyTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 11,
                    color: greyTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Row 3: Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: trip.progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),

            // Row 4: Timeline Counters
            Row(
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 14, color: greyTextColor),
                const SizedBox(width: 4),
                Text(
                  "${trip.stopsCount} stops",
                  style: TextStyle(
                    fontSize: 12,
                    color: greyTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.check_circle_outline,
                    size: 14, color: greyTextColor),
                const SizedBox(width: 4),
                Text(
                  "${trip.doneCount} done",
                  style: TextStyle(
                    fontSize: 12,
                    color: greyTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
