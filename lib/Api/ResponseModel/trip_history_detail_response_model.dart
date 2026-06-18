class TripHistoryDetailResponseModel {
  final String? status;
  final String? message;
  final HistoryTripDetail? trip;

  TripHistoryDetailResponseModel({
    this.status,
    this.message,
    this.trip,
  });

  factory TripHistoryDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return TripHistoryDetailResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      trip: json['trip'] != null
          ? HistoryTripDetail.fromJson(json['trip'] as Map<String, dynamic>)
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

class HistoryTripDetail {
  final int? tripId;
  final String? tripName;
  final String? tripDate;
  final String? plantName;
  final String? routeName;
  final String? driverName;
  final String? vehicleName;
  final String? startTime;
  final String? endTime;
  final int? totalOrders;
  final double? totalAmount;
  final double? totalWeight;
  final List<HistoryOrder>? orders;

  HistoryTripDetail({
    this.tripId,
    this.tripName,
    this.tripDate,
    this.plantName,
    this.routeName,
    this.driverName,
    this.vehicleName,
    this.startTime,
    this.endTime,
    this.totalOrders,
    this.totalAmount,
    this.totalWeight,
    this.orders,
  });

  factory HistoryTripDetail.fromJson(Map<String, dynamic> json) {
    return HistoryTripDetail(
      tripId: json['trip_id'] as int?,
      tripName: json['trip_name'] as String?,
      tripDate: json['trip_date'] as String?,
      plantName: json['plant_name'] as String?,
      routeName: json['route_name'] as String?,
      driverName: json['driver_name'] as String?,
      vehicleName: json['vehicle_name'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      totalOrders: json['total_orders'] as int?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      totalWeight: (json['total_weight'] as num?)?.toDouble(),
      orders: json['orders'] != null
          ? (json['orders'] as List)
              .map((i) => HistoryOrder.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trip_id'] = tripId;
    data['trip_name'] = tripName;
    data['trip_date'] = tripDate;
    data['plant_name'] = plantName;
    data['route_name'] = routeName;
    data['driver_name'] = driverName;
    data['vehicle_name'] = vehicleName;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['total_orders'] = totalOrders;
    data['total_amount'] = totalAmount;
    data['total_weight'] = totalWeight;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HistoryOrder {
  final int? orderId;
  final String? orderName;
  final String? customerName;
  final String? mobile;
  final double? amountTotal;
  final String? state;
  final bool? otpVerified;
  final String? deliveryDate;
  final bool? signatureUploaded;
  final bool? podUploaded;

  HistoryOrder({
    this.orderId,
    this.orderName,
    this.customerName,
    this.mobile,
    this.amountTotal,
    this.state,
    this.otpVerified,
    this.deliveryDate,
    this.signatureUploaded,
    this.podUploaded,
  });

  factory HistoryOrder.fromJson(Map<String, dynamic> json) {
    return HistoryOrder(
      orderId: json['order_id'] as int?,
      orderName: json['order_name'] as String?,
      customerName: json['customer_name'] as String?,
      mobile: json['mobile'] as String?,
      amountTotal: (json['amount_total'] as num?)?.toDouble(),
      state: json['state'] as String?,
      otpVerified: json['otp_verified'] as bool?,
      deliveryDate: json['delivery_date'] as String?,
      signatureUploaded: json['signature_uploaded'] as bool?,
      podUploaded: json['pod_uploaded'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_name'] = orderName;
    data['customer_name'] = customerName;
    data['mobile'] = mobile;
    data['amount_total'] = amountTotal;
    data['state'] = state;
    data['otp_verified'] = otpVerified;
    data['delivery_date'] = deliveryDate;
    data['signature_uploaded'] = signatureUploaded;
    data['pod_uploaded'] = podUploaded;
    return data;
  }
}
