class Driver {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String baseLocation;
  final double rating;
  int totalDeliveries;
  double onTimeRate;
  int thisMonthDeliveries;
  final String vehicleReg;
  final String vehicleLicense;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.baseLocation,
    required this.rating,
    required this.totalDeliveries,
    required this.onTimeRate,
    required this.thisMonthDeliveries,
    required this.vehicleReg,
    required this.vehicleLicense,
  });
}

class RouteStop {
  final int index;
  final String name;
  final String lat;
  final String lng;
  String status; // "Delivered" | "Active" | "Upcoming"
  final String address;
  final String phone;
  final String contactPerson;
  final int barrelsQty;
  final int cansQty;
  final String timeRange;
  final String otpCode;
  String? signatureBase64;
  String? podPhotoPath;

  RouteStop({
    required this.index,
    required this.name,
    required this.lat,
    required this.lng,
    required this.status,
    required this.address,
    required this.phone,
    required this.contactPerson,
    required this.barrelsQty,
    required this.cansQty,
    required this.timeRange,
    required this.otpCode,
    this.signatureBase64,
    this.podPhotoPath,
  });
}

class Trip {
  final String id;
  String status; // "In Progress" | "Done"
  final String date;
  final int stopsCount; // Count of petrol pumps (excluding plant)
  int doneCount; // Count of completed petrol pumps
  final List<RouteStop> stops; // Total list (Plant at 0, Pumps at 1..N)
  final double totalAmount;
  final String vehicleReg;
  final String totalDistance;
  final String eta;
  final int? dbTripId;

  Trip({
    required this.id,
    required this.status,
    required this.date,
    required this.stopsCount,
    required this.doneCount,
    required this.stops,
    required this.totalAmount,
    required this.vehicleReg,
    required this.totalDistance,
    required this.eta,
    this.dbTripId,
  });

  int get pendingCount => stopsCount - doneCount;
  double get progress => stopsCount == 0 ? 0.0 : doneCount / stopsCount;
}

class MockDataRepository {
  static final Driver currentDriver = Driver(
    id: "DRV12345",
    name: "Rajesh Kumar",
    email: "rajesh.kumar@defdelivery.com",
    phone: "+91 98765 43210",
    baseLocation: "Chennai Plant",
    rating: 4.8,
    totalDeliveries: 2847,
    onTimeRate: 98.0,
    thisMonthDeliveries: 156,
    vehicleReg: "TN 01 AB 1234",
    vehicleLicense: "TN-1234567890",
  );

  static final List<Trip> trips = [
    Trip(
      id: "TRIP001",
      status: "In Progress",
      date: "May 25, 2026",
      stopsCount: 8, // 8 petrol pumps
      doneCount: 3, // 3 completed (1, 2, 3)
      totalAmount: 245000.0,
      vehicleReg: "TN 01 AB 1234",
      totalDistance: "45 km",
      eta: "2h 30m",
      stops: [
        RouteStop(
          index: 0,
          name: "Chennai Plant",
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
        ),
        RouteStop(
          index: 1,
          name: "Shell Petrol Pump - Anna Nagar",
          lat: "13.0878° N",
          lng: "80.2093° E",
          status: "Delivered",
          address: "123, Anna Nagar West, Chennai - 600040",
          phone: "+91 91234 56781",
          contactPerson: "Magesh Kumar",
          barrelsQty: 20,
          cansQty: 10,
          timeRange: "09:00 AM - 10:00 AM",
          otpCode: "111111",
          signatureBase64: "mock_sig_1",
          podPhotoPath: "mock_photo_1",
        ),
        RouteStop(
          index: 2,
          name: "HP Petrol Station - T Nagar",
          lat: "13.0418° N",
          lng: "80.2341° E",
          status: "Delivered",
          address: "456, T Nagar Main Road, Chennai - 600017",
          phone: "+91 91234 56782",
          contactPerson: "Suresh Babu",
          barrelsQty: 15,
          cansQty: 0,
          timeRange: "10:30 AM - 11:00 AM",
          otpCode: "222222",
          signatureBase64: "mock_sig_2",
          podPhotoPath: "mock_photo_2",
        ),
        RouteStop(
          index: 3,
          name: "Indian Oil - Adyar",
          lat: "13.0067° N",
          lng: "80.2206° E",
          status: "Delivered",
          address: "789, Adyar Signal, Chennai - 600020",
          phone: "+91 91234 56783",
          contactPerson: "Ramesh Sharma",
          barrelsQty: 10,
          cansQty: 10,
          timeRange: "11:30 AM - 12:00 PM",
          otpCode: "333333",
          signatureBase64: "mock_sig_3",
          podPhotoPath: "mock_photo_3",
        ),
        RouteStop(
          index: 4,
          name: "Bharat Petroleum - Velachery",
          lat: "12.9758° N",
          lng: "80.2206° E",
          status: "Active", // Current Active stop
          address: "321, Velachery Main Road, Chennai - 600042",
          phone: "+91 98765 12345",
          contactPerson: "Karthik Raja",
          barrelsQty: 18,
          cansQty: 0,
          timeRange: "01:00 PM - 01:30 PM",
          otpCode: "432100",
        ),
        RouteStop(
          index: 5,
          name: "Essar Petrol Pump - Porur",
          lat: "13.0358° N",
          lng: "80.1564° E",
          status: "Upcoming",
          address: "654, Porur Junction, Chennai - 600116",
          phone: "+91 91234 56785",
          contactPerson: "Vijay Dev",
          barrelsQty: 22,
          cansQty: 15,
          timeRange: "02:00 PM - 02:30 PM",
          otpCode: "555555",
        ),
        RouteStop(
          index: 6,
          name: "Reliance Petroleum - Tambaram",
          lat: "12.9249° N",
          lng: "80.1000° E",
          status: "Upcoming",
          address: "88, Tambaram Bridge Road, Chennai - 600045",
          phone: "+91 91234 56786",
          contactPerson: "Rajesh V",
          barrelsQty: 12,
          cansQty: 5,
          timeRange: "03:00 PM - 03:30 PM",
          otpCode: "666666",
        ),
        RouteStop(
          index: 7,
          name: "BPCL Petrol Station - Guindy",
          lat: "13.0067° N",
          lng: "80.2206° E",
          status: "Upcoming",
          address: "42, Guindy Industrial Estate, Chennai - 600032",
          phone: "+91 91234 56787",
          contactPerson: "Balaji S",
          barrelsQty: 8,
          cansQty: 12,
          timeRange: "04:00 PM - 04:30 PM",
          otpCode: "777777",
        ),
        RouteStop(
          index: 8,
          name: "Nayara Fuel - Poonamallee",
          lat: "13.0472° N",
          lng: "80.0945° E",
          status: "Upcoming",
          address: "105, Poonamallee High Road, Chennai - 600056",
          phone: "+91 91234 56788",
          contactPerson: "Saravanan P",
          barrelsQty: 15,
          cansQty: 8,
          timeRange: "05:00 PM - 05:30 PM",
          otpCode: "888888",
        ),
      ],
    ),
    Trip(
      id: "TRIP098",
      status: "Done",
      date: "May 24, 2026",
      stopsCount: 12,
      doneCount: 12,
      totalAmount: 385000.0,
      vehicleReg: "TN 01 AB 1234",
      totalDistance: "72 km",
      eta: "0m",
      stops: List.generate(
        13,
        (i) => RouteStop(
          index: i,
          name: i == 0 ? "Chennai Plant" : "Petrol Pump $i",
          lat: "13.0000° N",
          lng: "80.0000° E",
          status: "Delivered",
          address: "Stops details address $i",
          phone: "+91 90000 000$i",
          contactPerson: "Manager $i",
          barrelsQty: 5,
          cansQty: 5,
          timeRange: "10:00 AM - 11:00 AM",
          otpCode: "9999",
        ),
      ),
    ),
    Trip(
      id: "TRIP097",
      status: "Done",
      date: "May 24, 2026",
      stopsCount: 6,
      doneCount: 6,
      totalAmount: 145000.0,
      vehicleReg: "TN 01 AB 1234",
      totalDistance: "35 km",
      eta: "0m",
      stops: List.generate(
        7,
        (i) => RouteStop(
          index: i,
          name: i == 0 ? "Chennai Plant" : "Petrol Pump $i",
          lat: "13.0000° N",
          lng: "80.0000° E",
          status: "Delivered",
          address: "Stops details address $i",
          phone: "+91 90000 000$i",
          contactPerson: "Manager $i",
          barrelsQty: 4,
          cansQty: 4,
          timeRange: "10:00 AM - 11:00 AM",
          otpCode: "8888",
        ),
      ),
    ),
  ];

  static bool verifyOTP(String tripId, int stopIndex, String enteredOTP) {
    try {
      final trip = trips.firstWhere((t) => t.id == tripId);
      final stop = trip.stops.firstWhere((s) => s.index == stopIndex);
      return stop.otpCode == enteredOTP;
    } catch (e) {
      return false;
    }
  }

  static bool completeDelivery(
    String tripId,
    int stopIndex, {
    required String signatureBase64,
    required String photoPath,
  }) {
    try {
      final trip = trips.firstWhere((t) => t.id == tripId);
      final stop = trip.stops.firstWhere((s) => s.index == stopIndex);

      stop.status = "Delivered";
      stop.signatureBase64 = signatureBase64;
      stop.podPhotoPath = photoPath;

      // Update doneCount (excluding the Plant at index 0)
      int completed = 0;
      for (int i = 1; i < trip.stops.length; i++) {
        if (trip.stops[i].status == "Delivered") {
          completed++;
        }
      }
      trip.doneCount = completed;

      // Find and activate next upcoming stop
      bool foundNext = false;
      for (int i = 1; i < trip.stops.length; i++) {
        var s = trip.stops[i];
        if (s.status == "Upcoming" && !foundNext) {
          s.status = "Active";
          foundNext = true;
        }
      }

      // If all stops are delivered, mark trip as Done
      if (trip.doneCount >= trip.stopsCount) {
        trip.status = "Done";
        currentDriver.thisMonthDeliveries += 1;
        currentDriver.totalDeliveries += 1;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
