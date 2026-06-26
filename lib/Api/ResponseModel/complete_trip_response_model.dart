import '../Utils/api_parser.dart';

class CompleteTripResponseModel {
  final String? status;
  final String? message;
  final CompletedTripDetails? trip;

  CompleteTripResponseModel({
    this.status,
    this.message,
    this.trip,
  });

  factory CompleteTripResponseModel.fromJson(Map<String, dynamic> json) {
    return CompleteTripResponseModel(
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
      trip: json['trip'] != null
          ? CompletedTripDetails.fromJson(json['trip'] as Map<String, dynamic>)
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

class CompletedTripDetails {
  final int? tripId;
  final String? tripName;
  final String? status;
  final String? startTime;
  final String? endTime;
  final String? driverName;
  final String? vehicleName;
  final int? totalOrders;
  final double? totalAmount;
  final double? totalWeight;

  CompletedTripDetails({
    this.tripId,
    this.tripName,
    this.status,
    this.startTime,
    this.endTime,
    this.driverName,
    this.vehicleName,
    this.totalOrders,
    this.totalAmount,
    this.totalWeight,
  });

  factory CompletedTripDetails.fromJson(Map<String, dynamic> json) {
    return CompletedTripDetails(
      tripId: ApiParser.parseInt(json['trip_id']),
      tripName: ApiParser.parseString(json['trip_name']),
      status: ApiParser.parseString(json['status']),
      startTime: ApiParser.parseString(json['start_time']),
      endTime: ApiParser.parseString(json['end_time']),
      driverName: ApiParser.parseString(json['driver_name']),
      vehicleName: ApiParser.parseString(json['vehicle_name']),
      totalOrders: ApiParser.parseInt(json['total_orders']),
      totalAmount: ApiParser.parseDouble(json['total_amount']),
      totalWeight: ApiParser.parseDouble(json['total_weight']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trip_id'] = tripId;
    data['trip_name'] = tripName;
    data['status'] = status;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['driver_name'] = driverName;
    data['vehicle_name'] = vehicleName;
    data['total_orders'] = totalOrders;
    data['total_amount'] = totalAmount;
    data['total_weight'] = totalWeight;
    return data;
  }
}
