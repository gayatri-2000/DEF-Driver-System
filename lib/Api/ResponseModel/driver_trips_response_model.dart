import 'package:def_driver_system/Api/ResponseModel/trip_detail_response_model.dart';
import '../Utils/api_parser.dart';

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
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
      tripCount: ApiParser.parseInt(json['trip_count']),
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
      tripId: ApiParser.parseInt(json['trip_id']),
      tripName: ApiParser.parseString(json['trip_name']),
      tripSheetNumber: ApiParser.parseString(json['trip_sheet_number']),
      tripDate: ApiParser.parseString(json['trip_date']),
      status: ApiParser.parseString(json['status']),
      startTime: ApiParser.parseString(json['start_time']),
      endTime: ApiParser.parseString(json['end_time']),
      orderCount: ApiParser.parseInt(json['order_count']),
      totalAmount: ApiParser.parseDouble(json['total_amount']),
      totalWeight: ApiParser.parseDouble(json['total_weight']),
      vehicleCapacity: ApiParser.parseDouble(json['vehicle_capacity']),
      notes: ApiParser.parseString(json['notes']),
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
