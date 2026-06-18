import 'package:def_driver_system/Api/ResponseModel/trip_detail_response_model.dart';

class DriverTripsResponseModel {
  final String? status;
  final String? message;
  final int? tripCount;
  final List<DriverTrip>? trips;

  DriverTripsResponseModel({
    this.status,
    this.message,
    this.tripCount,
    this.trips,
  });

  factory DriverTripsResponseModel.fromJson(Map<String, dynamic> json) {
    return DriverTripsResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      tripCount: json['trip_count'] as int?,
      trips: json['trips'] != null
          ? (json['trips'] as List)
              .map((i) => DriverTrip.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['trip_count'] = tripCount;
    if (trips != null) {
      data['trips'] = trips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DriverTrip {
  final int? tripId;
  final String? tripName;
  final String? tripSheetNumber;
  final String? tripDate;
  final String? status;
  final String? startTime;
  final String? endTime;
  final int? orderCount;
  final double? totalAmount;
  final double? totalWeight;
  final double? vehicleCapacity;
  final String? notes;
  final TripEntityReference? plant;
  final TripEntityReference? route;
  final TripEntityReference? vehicle;

  DriverTrip({
    this.tripId,
    this.tripName,
    this.tripSheetNumber,
    this.tripDate,
    this.status,
    this.startTime,
    this.endTime,
    this.orderCount,
    this.totalAmount,
    this.totalWeight,
    this.vehicleCapacity,
    this.notes,
    this.plant,
    this.route,
    this.vehicle,
  });

  factory DriverTrip.fromJson(Map<String, dynamic> json) {
    return DriverTrip(
      tripId: json['trip_id'] as int?,
      tripName: json['trip_name'] as String?,
      tripSheetNumber: json['trip_sheet_number'] as String?,
      tripDate: json['trip_date'] as String?,
      status: json['status'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      orderCount: json['order_count'] as int?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      totalWeight: (json['total_weight'] as num?)?.toDouble(),
      vehicleCapacity: (json['vehicle_capacity'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      plant: json['plant'] != null
          ? TripEntityReference.fromJson(json['plant'] as Map<String, dynamic>)
          : null,
      route: json['route'] != null
          ? TripEntityReference.fromJson(json['route'] as Map<String, dynamic>)
          : null,
      vehicle: json['vehicle'] != null
          ? TripEntityReference.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trip_id'] = tripId;
    data['trip_name'] = tripName;
    data['trip_sheet_number'] = tripSheetNumber;
    data['trip_date'] = tripDate;
    data['status'] = status;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['order_count'] = orderCount;
    data['total_amount'] = totalAmount;
    data['total_weight'] = totalWeight;
    data['vehicle_capacity'] = vehicleCapacity;
    data['notes'] = notes;
    if (plant != null) {
      data['plant'] = plant!.toJson();
    }
    if (route != null) {
      data['route'] = route!.toJson();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    return data;
  }
}
