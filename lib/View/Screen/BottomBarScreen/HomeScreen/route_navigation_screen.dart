import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:def_driver_system/View/Controller/trip_controller.dart';
import 'package:def_driver_system/View/Constant/app_color.dart';
import 'package:def_driver_system/Api/Repo/mock_data.dart';
import 'package:def_driver_system/View/Screen/Delivery/delivery_verification_screen.dart';
import 'package:def_driver_system/View/Utils/app_layout.dart';

class RouteNavigationScreen extends StatefulWidget {
  const RouteNavigationScreen({super.key});

  @override
  State<RouteNavigationScreen> createState() => _RouteNavigationScreenState();
}

class _RouteNavigationScreenState extends State<RouteNavigationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.stop();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: GetBuilder<TripController>(
          builder: (controller) {
            final tripId = controller.activeTrip?.id ?? "No Active Trip";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trip $tripId",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Route Navigation",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
      ),
      body: GetBuilder<TripController>(
        builder: (controller) {
          final trip = controller.activeTrip;

          if (trip == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_outlined, size: 64, color: greyTextColor),
                  const SizedBox(height: 16),
                  const Text(
                    "No Active Trip Assigned",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ask Logistics Manager to assign a route.",
                    style: TextStyle(color: greyTextColor),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Simulated Map Section with Overlay Card
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // The Map Canvas
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade100, Colors.blue.shade50],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: ClipRect(
                        child: Stack(
                          children: [
                            // Custom painted dotted route path
                            Positioned.fill(
                              child: CustomPaint(
                                painter: MapRoutePainter(),
                              ),
                            ),
                            // Map Pins
                            const Positioned(
                              top: 40,
                              left: 30,
                              child: Icon(Icons.location_on, color: Colors.green, size: 20),
                            ),
                            const Positioned(
                              bottom: 60,
                              right: 40,
                              child: Icon(Icons.location_on, color: Colors.grey, size: 20),
                            ),
                            // Current Active Pulse Pin in Center
                            Center(
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 44 * _pulseAnimation.value,
                                        height: 44 * _pulseAnimation.value,
                                        decoration: BoxDecoration(
                                          color: appColor.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.navigation,
                                        color: appColor,
                                        size: 28,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  "Interactive Map View",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0C243E),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Metrics overlay card
                    Positioned(
                      bottom: -40,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            _buildMapMetricCol(trip.totalDistance, "Distance"),
                            Container(width: 1, height: 32, color: Colors.grey.shade200),
                            _buildMapMetricCol(trip.eta, "ETA"),
                            Container(width: 1, height: 32, color: Colors.grey.shade200),
                            _buildMapMetricCol("${trip.pendingCount}/${trip.stopsCount}", "Stops"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 56),

                // 2. Open in Google Maps Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      successSnackBar(
                        "Google Maps",
                        "Opening Google Maps external navigation sequence...",
                      );
                    },
                    icon: const Icon(Icons.navigation_outlined, color: Colors.white, size: 20),
                    label: const Text(
                      "Open in Google Maps",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Route Stops Title and timeline list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Route Stops",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0C243E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trip.stops.length,
                        itemBuilder: (context, index) {
                          final stop = trip.stops[index];
                          final isLast = index == trip.stops.length - 1;
                          return _buildTimelineItem(context, stop, index, isLast, trip.id);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapMetricCol(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff0C243E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: greyTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, RouteStop stop, int index, bool isLast, String tripId) {
    bool isDelivered = stop.status == "Delivered";
    bool isActive = stop.status == "Active";
    bool isPlant = index == 0;

    Color circleColor = Colors.grey.shade300;
    Widget circleChild = Text(
      "$index",
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
    );

    if (isPlant) {
      circleColor = const Color(0xffE6F4EA);
      circleChild = Icon(Icons.inventory_2_outlined, color: greenColor, size: 18);
    } else if (isDelivered) {
      circleColor = const Color(0xffE6F4EA);
      circleChild = Text(
        "$index",
        style: TextStyle(fontWeight: FontWeight.bold, color: greenColor, fontSize: 12),
      );
    } else if (isActive) {
      circleColor = appColor.withOpacity(0.15);
      circleChild = Text(
        "$index",
        style: const TextStyle(fontWeight: FontWeight.bold, color: appColor, fontSize: 12),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: appColor, width: 2) : null,
                ),
                child: Center(child: circleChild),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isActive ? appColor : const Color(0xff0C243E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${stop.lat}, ${stop.lng}",
                    style: TextStyle(
                      fontSize: 12,
                      color: greyTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  if (isDelivered && !isPlant)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xffE6F4EA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: greenColor.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, size: 12, color: greenColor),
                          const SizedBox(width: 4),
                          Text(
                            "Delivered",
                            style: TextStyle(
                              color: greenColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                  if (isActive && !isPlant) ...[
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            successSnackBar(
                              "Calling Customer",
                              "Connecting call to ${stop.contactPerson} (${stop.phone})...",
                            );
                          },
                          icon: const Icon(Icons.phone_outlined, size: 16, color: appColor),
                          label: const Text(
                            "Call",
                            style: TextStyle(color: appColor, fontSize: 13),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: appColor),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Deliver Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (stop.status == "Upcoming" && !isPlant)
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: greyTextColor),
                        const SizedBox(width: 4),
                        Text(
                          "Upcoming",
                          style: TextStyle(
                            fontSize: 12,
                            color: greyTextColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to draw a beautiful dotted path curve
class MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = appColor.withOpacity(0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Start at top-left
    path.moveTo(0, size.height * 0.25);
    // Draw bezier curve to bottom-right
    path.cubicTo(
      size.width * 0.3, size.height * 0.1,
      size.width * 0.7, size.height * 0.7,
      size.width, size.height * 0.4,
    );

    // Draw dotted line
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;
    double distance = 0.0;

    for (var pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
