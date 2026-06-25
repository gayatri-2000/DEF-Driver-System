import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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

class _RouteNavigationScreenState extends State<RouteNavigationScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  Future<void> _makeCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanPhone,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        await launchUrl(launchUri);
      }
    } catch (e) {
      errorSnackBar("Call Error", "Could not place a call to $phoneNumber");
    }
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: cleanPhone,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        await launchUrl(launchUri);
      }
    } catch (e) {
      errorSnackBar("SMS Error", "Could not send SMS to $phoneNumber");
    }
  }

  double _parseCoordinate(String coordinate) {
    final clean = coordinate
        .replaceAll('°', '')
        .replaceAll('N', '')
        .replaceAll('S', '')
        .replaceAll('E', '')
        .replaceAll('W', '')
        .trim();
    double value = double.tryParse(clean) ?? 0.0;
    if (coordinate.contains('S') || coordinate.contains('W')) {
      value = -value;
    }
    return value;
  }

  void _buildMapData(Trip trip) {
    _markers.clear();
    _polylines.clear();

    final List<LatLng> points = [];

    for (int i = 0; i < trip.stops.length; i++) {
      final stop = trip.stops[i];
      final double lat = _parseCoordinate(stop.lat);
      final double lng = _parseCoordinate(stop.lng);
      final LatLng latLng = LatLng(lat, lng);
      points.add(latLng);

      double markerColor = BitmapDescriptor.hueRed;
      if (i == 0) {
        markerColor = BitmapDescriptor.hueGreen;
      } else if (stop.status == "Delivered") {
        markerColor = BitmapDescriptor.hueAzure;
      } else if (stop.status == "Active") {
        markerColor = BitmapDescriptor.hueOrange;
      }

      _markers.add(
        Marker(
          markerId: MarkerId('stop_${stop.index}_$i'),
          position: latLng,
          infoWindow: InfoWindow(
            title: stop.name,
            snippet: '${stop.status} - Qty: ${stop.barrelsQty} Barrels, ${stop.cansQty} Cans',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
        ),
      );
    }

    if (points.isNotEmpty) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route_path'),
          points: points,
          color: appColor,
          width: 4,
        ),
      );
    }
  }

  void _fitMapBounds(List<LatLng> points) {
    if (_mapController == null || points.isEmpty) return;

    double? minLat, maxLat, minLng, maxLng;
    for (final point in points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }

    if (minLat != null && maxLat != null && minLng != null && maxLng != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          50.0,
        ),
      );
    }
  }

  void _openGoogleMaps(Trip trip) async {
    RouteStop? activeStop;
    try {
      activeStop = trip.stops.firstWhere((s) => s.status == "Active" && s.index != 0);
    } catch (_) {
      try {
        activeStop = trip.stops.firstWhere((s) => s.status == "Upcoming" && s.index != 0);
      } catch (_) {
        if (trip.stops.length > 1) {
          activeStop = trip.stops[1];
        }
      }
    }

    if (activeStop != null) {
      final double lat = _parseCoordinate(activeStop.lat);
      final double lng = _parseCoordinate(activeStop.lng);
      final String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
      final Uri uri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        errorSnackBar("Maps Error", "Could not open Google Maps app.");
      }
    } else {
      errorSnackBar("Maps Error", "No active stop location found.");
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
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
                  Icon(Icons.local_shipping_outlined,
                      size: 64, color: greyTextColor),
                  const SizedBox(height: 16),
                  const Text(
                    "No Active Trip Assigned",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0C243E)),
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

          _buildMapData(trip);
          final List<LatLng> points = trip.stops.map((stop) {
            return LatLng(_parseCoordinate(stop.lat), _parseCoordinate(stop.lng));
          }).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (controller.isOffline) _buildOfflineBanner(),
                // 1. Simulated Map Section with Overlay Card
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // The Map Canvas
                    SizedBox(
                      height: 220,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: points.isNotEmpty ? points.first : const LatLng(13.0827, 80.2707),
                          zoom: 12,
                        ),
                        markers: _markers,
                        polylines: _polylines,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          if (points.isNotEmpty) {
                            Future.delayed(const Duration(milliseconds: 300), () {
                              _fitMapBounds(points);
                            });
                          }
                        },
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: true,
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
                            Container(
                                width: 1,
                                height: 32,
                                color: Colors.grey.shade200),
                            _buildMapMetricCol(trip.eta, "ETA"),
                            Container(
                                width: 1,
                                height: 32,
                                color: Colors.grey.shade200),
                            _buildMapMetricCol(
                                "${trip.pendingCount}/${trip.stopsCount}",
                                "Stops"),
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
                    onPressed: () => _openGoogleMaps(trip),
                    icon: const Icon(Icons.navigation_outlined,
                        color: Colors.white, size: 20),
                    label: const Text(
                      "Open in Google Maps",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
                          return _buildTimelineItem(
                              context, stop, index, isLast, trip.id);
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

  Widget _buildTimelineItem(BuildContext context, RouteStop stop, int index,
      bool isLast, String tripId) {
    bool isDelivered = stop.status == "Delivered";
    bool isActive = stop.status == "Active";
    bool isPlant = index == 0;

    Color circleColor = Colors.grey.shade300;
    Widget circleChild = Text(
      "$index",
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
    );

    if (isPlant) {
      circleColor = const Color(0xffE6F4EA);
      circleChild =
          Icon(Icons.inventory_2_outlined, color: greenColor, size: 18);
    } else if (isDelivered) {
      circleColor = const Color(0xffE6F4EA);
      circleChild = Text(
        "$index",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: greenColor, fontSize: 12),
      );
    } else if (isActive) {
      circleColor = appColor.withOpacity(0.15);
      circleChild = Text(
        "$index",
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: appColor, fontSize: 12),
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
                  border:
                      isActive ? Border.all(color: appColor, width: 2) : null,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _sendSMS(stop.phone),
                          icon: const Icon(Icons.message_outlined,
                              size: 16, color: appColor),
                          label: const Text(
                            "SMS",
                            style: TextStyle(color: appColor, fontSize: 13),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: appColor),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _makeCall(stop.phone),
                          icon: const Icon(Icons.phone_outlined,
                              size: 16, color: appColor),
                          label: const Text(
                            "Call",
                            style: TextStyle(color: appColor, fontSize: 13),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: appColor),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => DeliveryVerificationScreen(
                                  stopIndex: stop.index,
                                  pumpName: stop.name,
                                  barrelsQty: stop.barrelsQty,
                                  cansQty: stop.cansQty,
                                  expectedOtp: stop.otpCode,
                                  totalAmount: stop.totalAmount,
                                  address: stop.address,
                                  otpRequired: stop.otpRequired,
                                  otpVerified: stop.otpVerified,
                                  podRequired: stop.podRequired,
                                  podUploaded: stop.podUploaded,
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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

  Widget _buildOfflineBanner() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
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
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.7,
      size.height * 0.7,
      size.width,
      size.height * 0.4,
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
