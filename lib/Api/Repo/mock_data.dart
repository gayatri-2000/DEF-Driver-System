class Driver {
  final String id;
  final String name;
  final String email;
  final String phone;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
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
  final double totalAmount;
  String? signatureBase64;
  String? podPhotoPath;
  final bool otpRequired;
  final bool otpVerified;
  final bool podRequired;
  final bool podUploaded;

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
    required this.totalAmount,
    this.signatureBase64,
    this.podPhotoPath,
    this.otpRequired = true,
    this.otpVerified = false,
    this.podRequired = true,
    this.podUploaded = false,
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

