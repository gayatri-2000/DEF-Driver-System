import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Api/Repo/mock_data.dart';
import '../../Api/Repo/dashboard_repo.dart';
import '../../Api/Repo/trip_repo.dart';
import '../../Api/ResponseModel/dashboard_response_model.dart';
import '../../Api/ResponseModel/trip_detail_response_model.dart';
import '../../Api/ResponseModel/start_trip_response_model.dart';
import '../../Api/ResponseModel/trip_history_response_model.dart';
import '../../Api/ResponseModel/trip_history_detail_response_model.dart';
import '../../Api/ResponseModel/send_delivery_otp_response_model.dart';
import '../../Api/ResponseModel/verify_otp_response_model.dart';
import '../../Api/ResponseModel/upload_pod_response_model.dart';
import '../../Api/ResponseModel/upload_signature_response_model.dart';
import '../../Api/ResponseModel/complete_order_response_model.dart';
import '../../Api/Apis/app_exception.dart';
import '../../View/Utils/app_layout.dart';
import '../Controller/auth_controller.dart';

class TripController extends GetxController {
  List<Trip> allTrips = [];
  List<Trip> filteredTrips = [];
  String searchQuery = '';

  List<Trip> completedTripsList = [];
  List<Trip> completedTripsFiltered = [];

  Trip? activeTrip;
  HistoryTripDetail? activeHistoryTripDetail;
  bool isLoading = false;
  DashboardStatistics? statistics;
  int activeTripId = -1; // Resolved dynamically from trips list

  final DashboardRepo _dashboardRepo = DashboardRepo();
  final TripRepo _tripRepo = TripRepo();

  @override
  void onInit() {
    super.onInit();
    loadTrips();
  }

  Future<void> loadTripDetails(int tripId) async {
    activeTripId = tripId;
    await loadTrips();
  }

  Future<void> loadTrips() async {
    isLoading = true;
    update();

    try {
      log("TripController: Fetching Odoo dashboard data...");
      final DashboardResponseModel dashboardData =
          await _dashboardRepo.fetchDashboard();
      statistics = dashboardData.statistics;

      // Dynamically resolve activeTripId:
      log("TripController: Checking for in-transit driver trips...");
      final inTransitRes = await _tripRepo.getDriverTrips('in_transit');
      if (inTransitRes.trips != null && inTransitRes.trips!.isNotEmpty) {
        activeTripId = inTransitRes.trips!.first.tripId ?? -1;
        log("TripController: Found in-transit trip ID: $activeTripId");
      } else {
        log("TripController: Checking for pending driver trips...");
        final pendingRes = await _tripRepo.getDriverTrips('pending');
        if (pendingRes.trips != null && pendingRes.trips!.isNotEmpty) {
          activeTripId = pendingRes.trips!.first.tripId ?? -1;
          log("TripController: Found pending trip ID: $activeTripId");
        } else {
          activeTripId = -1;
          log("TripController: No active or pending trips found.");
        }
      }

      if (activeTripId != -1) {
        log("TripController: Fetching Odoo trip details for tripId: $activeTripId...");
        final TripDetailResponseModel tripData =
            await _tripRepo.getTripDetail(activeTripId);

        if (tripData.trip != null) {
          final List<RouteStop> stops = [];

          // Add Chennai Plant as index 0 (the starting point)
          stops.add(RouteStop(
            index: 0,
            name: tripData.trip!.plant?.name?.isNotEmpty == true
                ? tripData.trip!.plant!.name!
                : "Chennai Plant",
            lat: "13.0827° N",
            lng: "80.2707° E",
            status: "Delivered",
            address: "10, Plant Road, Industrial Area, Chennai",
            phone: "+91 44223 34455",
            contactPerson: "Warehouse In-charge",
            barrelsQty: 0,
            cansQty: 0,
            timeRange: "08:00 AM - 08:30 AM",
            otpCode: "000000",
          ));

          final orders = tripData.trip!.orders ?? [];
          for (int i = 0; i < orders.length; i++) {
            final order = orders[i];

            // Map order state to stop status
            String uiStatus = "Upcoming";
            if (order.deliveryStatus == "delivered") {
              uiStatus = "Delivered";
            } else if (order.deliveryStatus == "in_transit") {
              uiStatus = "Active";
            } else if (order.deliveryStatus == "dispatched") {
              uiStatus = "Upcoming";
            }

            // Calculate barrels and cans by analyzing line items
            int barrels = 0;
            int cans = 0;
            final items = order.items ?? [];
            for (var item in items) {
              final name = (item.productName ?? "").toLowerCase();
              final qty = (item.quantity ?? 0.0).round();
              if (name.contains("can")) {
                cans += qty;
              } else {
                barrels += qty;
              }
            }

            // Fallback if no quantities found
            if (barrels == 0 && cans == 0) {
              if (order.amountTotal != null && order.amountTotal! > 0) {
                barrels = (order.amountTotal! / 2950.0).round();
                if (barrels == 0) barrels = 1;
              } else {
                barrels = 10;
              }
            }

            stops.add(RouteStop(
              index: order.orderId ?? (i + 1),
              name: order.customerName?.isNotEmpty == true
                  ? order.customerName!
                  : (order.orderName ?? "Order #${order.orderId}"),
              lat: order.latitude?.toString() ?? "13.0000° N",
              lng: order.longitude?.toString() ?? "80.0000° E",
              status: uiStatus,
              address: order.deliveryAddress?.isNotEmpty == true
                  ? order.deliveryAddress!
                  : "Chennai",
              phone: order.customerMobile?.isNotEmpty == true
                  ? order.customerMobile!
                  : "+91 98765 12345",
              contactPerson: order.customerName ?? "Customer Representative",
              barrelsQty: barrels,
              cansQty: cans,
              timeRange: tripData.trip!.tripDate ?? "Today",
              otpCode: order.deliveryOtp?.isNotEmpty == true
                  ? order.deliveryOtp!
                  : "123456",
              signatureBase64: order.podUploaded == true ? "uploaded_sig" : null,
              podPhotoPath: order.podUploaded == true ? "uploaded_photo" : null,
            ));
          }

          // Build Odoo active trip.
          String uiTripStatus = "In Progress";
          if (tripData.trip!.status == "delivered") {
            uiTripStatus = "Done";
          } else {
            uiTripStatus = "In Progress";
          }

          activeTrip = Trip(
            id: tripData.trip!.tripSheetNumber?.isNotEmpty == true
                ? tripData.trip!.tripSheetNumber!
                : "TS-0${tripData.trip!.tripId}",
            status: uiTripStatus,
            date: tripData.trip!.tripDate ?? "Today",
            stopsCount: tripData.trip!.totalOrders ?? (stops.length - 1),
            doneCount: stops
                .where((s) => s.status == "Delivered" && s.index != 0)
                .length,
            stops: stops,
            totalAmount: tripData.trip!.totalAmount ?? 0.0,
            vehicleReg: tripData.trip!.vehicle?.name?.isNotEmpty == true
                ? tripData.trip!.vehicle!.name!
                : "TN 01 AB 1234",
            totalDistance: "${(stops.length - 1) * 8} km",
            eta: "2h 15m",
          );

          // Save backend raw state in trip object
          final String rawState = tripData.trip!.status ?? "draft";
          activeTrip = Trip(
            id: activeTrip!.id,
            status: activeTrip!.status,
            date: activeTrip!.date,
            stopsCount: activeTrip!.stopsCount,
            doneCount: activeTrip!.doneCount,
            stops: activeTrip!.stops,
            totalAmount: activeTrip!.totalAmount,
            vehicleReg: "${activeTrip!.vehicleReg}|$rawState|$activeTripId",
            totalDistance: activeTrip!.totalDistance,
            eta: activeTrip!.eta,
          );

          allTrips = [activeTrip!];
          filteredTrips = List.from(allTrips);
        } else {
          throw Exception("Odoo trip object is null");
        }
      } else {
        activeTrip = null;
        allTrips = [];
        filteredTrips = [];
      }
    } catch (e) {
      log("TripController loadTrips error: $e.");
      activeTrip = null;
      allTrips = [];
      filteredTrips = [];

      if (e is UnauthorisedException) {
        log("TripController: Session expired. Logging out and redirecting to Login...");
        try {
          final AuthController authController = Get.find<AuthController>();
          authController.logout();
        } catch (err) {
          log("TripController: Error during auto-logout: $err");
        }
      } else {
        errorSnackBar(
          "Dashboard Error",
          e
              .toString()
              .replaceAll('FetchDataException:', '')
              .replaceAll('UnAuthorized Request:', '')
              .trim(),
        );
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> startTrip(int tripId) async {
    isLoading = true;
    update();
    try {
      log("TripController: Starting trip with ID: $tripId...");
      final StartTripResponseModel res = await _tripRepo.startTrip(tripId);
      if (res.status == "SUCCESS") {
        successSnackBar("Success", res.message ?? "Trip started successfully");
        try {
          await loadTrips();
        } catch (err) {
          log("TripController: loadTrips failed after starting trip (resuming): $err");
        }
        return true;
      } else {
        errorSnackBar("Failed", res.message ?? "Failed to start trip");
        return false;
      }
    } catch (e) {
      log("TripController startTrip error: $e");
      errorSnackBar(
        "Error starting trip",
        e
            .toString()
            .replaceAll('FetchDataException:', '')
            .replaceAll('UnAuthorized Request:', '')
            .trim(),
      );
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  void searchTrips(String query) {
    searchQuery = query;
    if (query.trim().isEmpty) {
      filteredTrips = List.from(allTrips);
    } else {
      filteredTrips = allTrips.where((trip) {
        return trip.id.toLowerCase().contains(query.toLowerCase()) ||
            trip.date.toLowerCase().contains(query.toLowerCase()) ||
            trip.status.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  bool verifyOTP(int stopIndex, String enteredOTP) {
    if (activeTrip == null) return false;
    try {
      final stop = activeTrip!.stops.firstWhere((s) => s.index == stopIndex);
      return stop.otpCode == enteredOTP;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitProofOfDelivery(
    int stopIndex, {
    required String signatureBase64,
    required String photoBase64,
    String podNotes = '',
  }) async {
    if (activeTrip == null) return false;

    isLoading = true;
    update();

    try {
      // 1. Upload POD Image
      log("TripController: Uploading POD photo for order: $stopIndex...");
      final UploadPodResponseModel podRes = await _tripRepo.uploadPod(stopIndex, photoBase64, podNotes);
      if (podRes.status != 'SUCCESS') {
        errorSnackBar("POD Upload Failed", podRes.message ?? "Failed to upload image");
        return false;
      }

      // 2. Upload Signature
      log("TripController: Uploading signature for order: $stopIndex...");
      final UploadSignatureResponseModel sigRes = await _tripRepo.uploadSignature(stopIndex, signatureBase64);
      if (sigRes.status != 'SUCCESS') {
        errorSnackBar("Signature Upload Failed", sigRes.message ?? "Failed to upload signature");
        return false;
      }

      // 3. Complete Order on backend
      log("TripController: Completing order: $stopIndex on Odoo...");
      final CompleteOrderResponseModel completeRes = await _tripRepo.completeOrder(stopIndex);
      if (completeRes.status != 'SUCCESS') {
        errorSnackBar("Order Completion Failed", completeRes.message ?? "Failed to complete order on backend");
        return false;
      }

      // 4. Mark locally as delivered and advance state
      final stop = activeTrip!.stops.firstWhere((s) => s.index == stopIndex);
      stop.status = "Delivered";
      stop.signatureBase64 = signatureBase64;
      stop.podPhotoPath = "uploaded_on_odoo"; // Mock path locally

      // Recalculate completed stops count (excluding index 0)
      int completed = 0;
      for (int i = 1; i < activeTrip!.stops.length; i++) {
        if (activeTrip!.stops[i].status == "Delivered") {
          completed++;
        }
      }
      activeTrip!.doneCount = completed;

      // Activate the next upcoming stop if any
      bool foundNext = false;
      for (int i = 1; i < activeTrip!.stops.length; i++) {
        var s = activeTrip!.stops[i];
        if (s.status == "Upcoming" && !foundNext) {
          s.status = "Active";
          foundNext = true;
        }
      }

      // Update statistics values locally
      if (statistics != null) {
        int delivered = statistics!.deliveredOrders ?? 0;
        int inTransit = statistics!.inTransitOrders ?? 0;
        statistics = DashboardStatistics(
          totalOrders: statistics!.totalOrders,
          deliveredOrders: delivered + 1,
          inTransitOrders: inTransit > 0 ? inTransit - 1 : 0,
          dispatchedOrders: statistics!.dispatchedOrders,
          cancelledOrders: statistics!.cancelledOrders,
          paidOrders: statistics!.paidOrders,
          pendingPayments: statistics!.pendingPayments,
          partialPayments: statistics!.partialPayments,
          totalAmount: statistics!.totalAmount,
          totalDue: statistics!.totalDue,
        );
      }

      // Silent reload of trip details from backend
      try {
        await loadTrips();
      } catch (err) {
        log("TripController: loadTrips failed after POD submission (resuming): $err");
      }

      return true;
    } catch (e) {
      log("TripController submitProofOfDelivery error: $e");
      errorSnackBar(
        "Upload Failed",
        e
            .toString()
            .replaceAll('FetchDataException:', '')
            .replaceAll('UnAuthorized Request:', '')
            .trim(),
      );
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  void simulateException(int stopIndex, String reason) {
    if (activeTrip == null) return;
    try {
      var stop = activeTrip!.stops.firstWhere((s) => s.index == stopIndex);
      stop.status = "Failed: $reason";
      update();
    } catch (_) {}
  }

  Future<void> fetchHistoryTrips() async {
    isLoading = true;
    update();
    try {
      log("TripController: Fetching driver trip history...");
      final TripHistoryResponseModel response =
          await _tripRepo.getTripHistory();

      final List<Trip> fetched = [];
      for (var dt in response.trips ?? []) {
        // Map backend state to UI status
        String uiStatus = "Done";
        if (dt.status != null) {
          final lowerStatus = dt.status!.toLowerCase();
          if (lowerStatus == 'delivered' || lowerStatus == 'done' || lowerStatus == 'completed') {
            uiStatus = "Done";
          } else {
            uiStatus = "In Progress";
          }
        }

        // Format Date from YYYY-MM-DD to MMMM d, yyyy
        String displayDate = "Today";
        if (dt.tripDate != null && dt.tripDate!.isNotEmpty) {
          try {
            final parsedDate = DateTime.parse(dt.tripDate!);
            displayDate = DateFormat("MMMM d, yyyy").format(parsedDate);
          } catch (_) {
            displayDate = dt.tripDate!;
          }
        }

        fetched.add(Trip(
          id: dt.tripName?.isNotEmpty == true
              ? dt.tripName!
              : "TS-0${dt.tripId}",
          status: uiStatus,
          date: displayDate,
          stopsCount: dt.totalOrders ?? 0,
          doneCount: uiStatus == "Done" ? (dt.totalOrders ?? 0) : 0,
          stops: [],
          totalAmount: dt.totalAmount ?? 0.0,
          vehicleReg: dt.vehicleName ?? "TN 01 AB 1234",
          totalDistance: "${(dt.totalOrders ?? 0) * 8} km",
          eta: uiStatus == "Done" ? "Completed" : "In Progress",
          dbTripId: dt.tripId,
        ));
      }
      completedTripsList = fetched;
      completedTripsFiltered = List.from(completedTripsList);
    } catch (e) {
      log("TripController fetchHistoryTrips error: $e");
      if (e is UnauthorisedException) {
        try {
          final AuthController authController = Get.find<AuthController>();
          authController.logout();
        } catch (err) {
          log("TripController: Error during auto-logout: $err");
        }
      } else {
        errorSnackBar(
          "History Error",
          e
              .toString()
              .replaceAll('FetchDataException:', '')
              .replaceAll('UnAuthorized Request:', '')
              .trim(),
        );
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  void searchHistoryTrips(String query) {
    if (query.trim().isEmpty) {
      completedTripsFiltered = List.from(completedTripsList);
    } else {
      completedTripsFiltered = completedTripsList.where((trip) {
        return trip.id.toLowerCase().contains(query.toLowerCase()) ||
            trip.date.toLowerCase().contains(query.toLowerCase()) ||
            trip.status.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  Future<bool> sendDeliveryOtp(int orderId) async {
    isLoading = true;
    update();
    try {
      log("TripController: Requesting OTP dispatch for order: $orderId...");
      final SendDeliveryOtpResponseModel res = await _tripRepo.sendDeliveryOtp(orderId);
      if (res.status == "SUCCESS") {
        successSnackBar("OTP Dispatched", res.message ?? "OTP sent successfully on WhatsApp");
        try {
          await loadTrips();
        } catch (err) {
          log("TripController: loadTrips failed after OTP dispatch (resuming): $err");
        }
        return true;
      } else {
        errorSnackBar("Failed to send OTP", res.message ?? "Something went wrong");
        return false;
      }
    } catch (e) {
      log("TripController sendDeliveryOtp error: $e");
      errorSnackBar(
        "Error sending OTP",
        e
            .toString()
            .replaceAll('FetchDataException:', '')
            .replaceAll('UnAuthorized Request:', '')
            .trim(),
      );
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> verifyDeliveryOtp(int orderId, String otp) async {
    isLoading = true;
    update();
    try {
      log("TripController: Requesting OTP verification for order: $orderId...");
      final VerifyOtpResponseModel res = await _tripRepo.verifyDeliveryOtp(orderId, otp);
      if (res.status == "SUCCESS") {
        successSnackBar("OTP Verified", res.message ?? "OTP verified successfully");
        try {
          await loadTrips();
        } catch (err) {
          log("TripController: loadTrips failed after OTP verify (resuming): $err");
        }
        return true;
      } else {
        errorSnackBar("Verification Failed", res.message ?? "Invalid OTP entered");
        return false;
      }
    } catch (e) {
      log("TripController verifyDeliveryOtp error: $e");
      errorSnackBar(
        "Error verifying OTP",
        e
            .toString()
            .replaceAll('FetchDataException:', '')
            .replaceAll('UnAuthorized Request:', '')
            .trim(),
      );
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchTripHistoryDetail(int tripId) async {
    isLoading = true;
    activeHistoryTripDetail = null;
    update();

    try {
      log("TripController: Fetching details for trip ID: $tripId...");
      final TripHistoryDetailResponseModel res = await _tripRepo.getTripHistoryDetail(tripId);
      if (res.status == "SUCCESS") {
        activeHistoryTripDetail = res.trip;
      } else {
        errorSnackBar("Failed to load details", res.message ?? "Something went wrong");
      }
    } catch (e) {
      log("TripController fetchTripHistoryDetail error: $e");
      errorSnackBar(
        "Error fetching details",
        e
            .toString()
            .replaceAll('FetchDataException:', '')
            .replaceAll('UnAuthorized Request:', '')
            .trim(),
      );
    } finally {
      isLoading = false;
      update();
    }
  }
}
