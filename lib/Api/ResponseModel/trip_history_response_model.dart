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
      status: json['status'] as String?,
      message: json['message'] as String?,
      tripCount: json['trip_count'] as int?,
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
      tripId: json['trip_id'] as int?,
      tripName: json['trip_name'] as String?,
      tripDate: json['trip_date'] as String?,
      plantName: json['plant_name'] as String?,
      routeName: json['route_name'] as String?,
      vehicleName: json['vehicle_name'] as String?,
      totalOrders: json['total_orders'] as int?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      totalWeight: (json['total_weight'] as num?)?.toDouble(),
      status: json['status'] as String?,
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
