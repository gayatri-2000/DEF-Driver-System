class StartTripResponseModel {
  final String? status;
  final String? message;
  final StartedTripDetails? trip;

  StartTripResponseModel({
    this.status,
    this.message,
    this.trip,
  });

  factory StartTripResponseModel.fromJson(Map<String, dynamic> json) {
    return StartTripResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      trip: json['trip'] != null
          ? StartedTripDetails.fromJson(json['trip'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (trip != null) {
      data['trip'] = trip!.toJson();
    }
    return data;
  }
}

class StartedTripDetails {
  final int? tripId;
  final String? tripName;
  final String? status;
  final String? startTime;
  final String? driverName;
  final String? vehicleName;
  final int? totalOrders;
  final double? totalAmount;

  StartedTripDetails({
    this.tripId,
    this.tripName,
    this.status,
    this.startTime,
    this.driverName,
    this.vehicleName,
    this.totalOrders,
    this.totalAmount,
  });

  factory StartedTripDetails.fromJson(Map<String, dynamic> json) {
    return StartedTripDetails(
      tripId: json['trip_id'] as int?,
      tripName: json['trip_name'] as String?,
      status: json['status'] as String?,
      startTime: json['start_time'] as String?,
      driverName: json['driver_name'] as String?,
      vehicleName: json['vehicle_name'] as String?,
      totalOrders: json['total_orders'] as int?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trip_id'] = tripId;
    data['trip_name'] = tripName;
    data['status'] = status;
    data['start_time'] = startTime;
    data['driver_name'] = driverName;
    data['vehicle_name'] = vehicleName;
    data['total_orders'] = totalOrders;
    data['total_amount'] = totalAmount;
    return data;
  }
}
