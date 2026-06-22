import '../Utils/api_parser.dart';

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
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
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
      tripId: ApiParser.parseInt(json['trip_id']),
      tripName: ApiParser.parseString(json['trip_name']),
      tripDate: ApiParser.parseString(json['trip_date']),
      plantName: ApiParser.parseString(json['plant_name']),
      routeName: ApiParser.parseString(json['route_name']),
      driverName: ApiParser.parseString(json['driver_name']),
      vehicleName: ApiParser.parseString(json['vehicle_name']),
      startTime: ApiParser.parseString(json['start_time']),
      endTime: ApiParser.parseString(json['end_time']),
      totalOrders: ApiParser.parseInt(json['total_orders']),
      totalAmount: ApiParser.parseDouble(json['total_amount']),
      totalWeight: ApiParser.parseDouble(json['total_weight']),
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
      orderId: ApiParser.parseInt(json['order_id']),
      orderName: ApiParser.parseString(json['order_name']),
      customerName: ApiParser.parseString(json['customer_name']),
      mobile: ApiParser.parseString(json['mobile']),
      amountTotal: ApiParser.parseDouble(json['amount_total']),
      state: ApiParser.parseString(json['state']),
      otpVerified: ApiParser.parseBool(json['otp_verified']),
      deliveryDate: ApiParser.parseString(json['delivery_date']),
      signatureUploaded: ApiParser.parseBool(json['signature_uploaded']),
      podUploaded: ApiParser.parseBool(json['pod_uploaded']),
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
