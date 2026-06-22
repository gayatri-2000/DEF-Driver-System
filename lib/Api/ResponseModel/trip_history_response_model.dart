import '../Utils/api_parser.dart';

class TripHistoryResponseModel {
  final String? status;
  final String? message;
  final int? tripCount;
  final List<HistoryTrip>? trips;

  TripHistoryResponseModel({
    this.status,
    this.message,
    this.tripCount,
    this.trips,
  });

  factory TripHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TripHistoryResponseModel(
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
      tripCount: ApiParser.parseInt(json['trip_count']),
      trips: json['trips'] != null
          ? (json['trips'] as List)
              .map((i) => HistoryTrip.fromJson(i as Map<String, dynamic>))
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

class HistoryTrip {
  final int? tripId;
  final String? tripName;
  final String? tripDate;
  final String? plantName;
  final String? routeName;
  final String? vehicleName;
  final int? totalOrders;
  final double? totalAmount;
  final double? totalWeight;
  final String? status;

  HistoryTrip({
    this.tripId,
    this.tripName,
    this.tripDate,
    this.plantName,
    this.routeName,
    this.vehicleName,
    this.totalOrders,
    this.totalAmount,
    this.totalWeight,
    this.status,
  });

  factory HistoryTrip.fromJson(Map<String, dynamic> json) {
    return HistoryTrip(
      tripId: ApiParser.parseInt(json['trip_id']),
      tripName: ApiParser.parseString(json['trip_name']),
      tripDate: ApiParser.parseString(json['trip_date']),
      plantName: ApiParser.parseString(json['plant_name']),
      routeName: ApiParser.parseString(json['route_name']),
      vehicleName: ApiParser.parseString(json['vehicle_name']),
      totalOrders: ApiParser.parseInt(json['total_orders']),
      totalAmount: ApiParser.parseDouble(json['total_amount']),
      totalWeight: ApiParser.parseDouble(json['total_weight']),
      status: ApiParser.parseString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trip_id'] = tripId;
    data['trip_name'] = tripName;
    data['trip_date'] = tripDate;
    data['plant_name'] = plantName;
    data['route_name'] = routeName;
    data['vehicle_name'] = vehicleName;
    data['total_orders'] = totalOrders;
    data['total_amount'] = totalAmount;
    data['total_weight'] = totalWeight;
    data['status'] = status;
    return data;
  }
}
