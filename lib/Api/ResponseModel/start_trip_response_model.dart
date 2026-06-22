import '../Utils/api_parser.dart';

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
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
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
      tripId: ApiParser.parseInt(json['trip_id']),
      tripName: ApiParser.parseString(json['trip_name']),
      status: ApiParser.parseString(json['status']),
      startTime: ApiParser.parseString(json['start_time']),
      driverName: ApiParser.parseString(json['driver_name']),
      vehicleName: ApiParser.parseString(json['vehicle_name']),
      totalOrders: ApiParser.parseInt(json['total_orders']),
      totalAmount: ApiParser.parseDouble(json['total_amount']),
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
