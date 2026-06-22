import '../Utils/api_parser.dart';

String? _parseString(dynamic value) => ApiParser.parseString(value);

class TripDetailResponseModel {
  final String? status;
  final String? message;
  final TripDetails? trip;

  TripDetailResponseModel({
    this.status,
    this.message,
    this.trip,
  });

  factory TripDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return TripDetailResponseModel(
      status: _parseString(json['status']),
      message: _parseString(json['message']),
      trip: json['trip'] != null
          ? TripDetails.fromJson(json['trip'] as Map<String, dynamic>)
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

class TripDetails {
  final int? tripId;
  final String? tripName;
  final String? tripSheetNumber;
  final String? tripDate;
  final String? status;
  final String? startTime;
  final String? endTime;
  final int? totalOrders;
  final double? totalAmount;
  final double? totalWeight;
  final double? vehicleCapacity;
  final String? notes;
  final TripEntityReference? plant;
  final TripEntityReference? route;
  final TripEntityReference? vehicle;
  final List<TripOrder>? orders;

  TripDetails({
    this.tripId,
    this.tripName,
    this.tripSheetNumber,
    this.tripDate,
    this.status,
    this.startTime,
    this.endTime,
    this.totalOrders,
    this.totalAmount,
    this.totalWeight,
    this.vehicleCapacity,
    this.notes,
    this.plant,
    this.route,
    this.vehicle,
    this.orders,
  });

  factory TripDetails.fromJson(Map<String, dynamic> json) {
    return TripDetails(
      tripId: json['trip_id'] as int?,
      tripName: _parseString(json['trip_name']),
      tripSheetNumber: _parseString(json['trip_sheet_number']),
      tripDate: _parseString(json['trip_date']),
      status: _parseString(json['status']),
      startTime: _parseString(json['start_time']),
      endTime: _parseString(json['end_time']),
      totalOrders: json['total_orders'] as int?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      totalWeight: (json['total_weight'] as num?)?.toDouble(),
      vehicleCapacity: (json['vehicle_capacity'] as num?)?.toDouble(),
      notes: _parseString(json['notes']),
      plant: json['plant'] != null ? TripEntityReference.fromJson(json['plant'] as Map<String, dynamic>) : null,
      route: json['route'] != null ? TripEntityReference.fromJson(json['route'] as Map<String, dynamic>) : null,
      vehicle: json['vehicle'] != null ? TripEntityReference.fromJson(json['vehicle'] as Map<String, dynamic>) : null,
      orders: json['orders'] != null
          ? (json['orders'] as List).map((e) => TripOrder.fromJson(e as Map<String, dynamic>)).toList()
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
    data['total_orders'] = totalOrders;
    data['total_amount'] = totalAmount;
    data['total_weight'] = totalWeight;
    data['vehicle_capacity'] = vehicleCapacity;
    data['notes'] = notes;
    if (plant != null) data['plant'] = plant!.toJson();
    if (route != null) data['route'] = route!.toJson();
    if (vehicle != null) data['vehicle'] = vehicle!.toJson();
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TripEntityReference {
  final dynamic id; // can be int or bool false
  final String? name;

  TripEntityReference({this.id, this.name});

  factory TripEntityReference.fromJson(Map<String, dynamic> json) {
    return TripEntityReference(
      id: json['id'],
      name: _parseString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class TripOrder {
  final int? orderId;
  final String? orderName;
  final String? customerName;
  final String? customerMobile;
  final String? deliveryAddress;
  final double? latitude;
  final double? longitude;
  final double? amountTotal;
  final String? paymentMethod;
  final String? deliveryStatus;
  final bool? otpVerified;
  final bool? otpRequired;
  final bool? podUploaded;
  final bool? podRequired;
  final String? deliveryOtp;
  final List<TripOrderItem>? items;

  TripOrder({
    this.orderId,
    this.orderName,
    this.customerName,
    this.customerMobile,
    this.deliveryAddress,
    this.latitude,
    this.longitude,
    this.amountTotal,
    this.paymentMethod,
    this.deliveryStatus,
    this.otpVerified,
    this.otpRequired,
    this.podUploaded,
    this.podRequired,
    this.deliveryOtp,
    this.items,
  });

  factory TripOrder.fromJson(Map<String, dynamic> json) {
    return TripOrder(
      orderId: json['order_id'] as int?,
      orderName: _parseString(json['order_name']),
      customerName: _parseString(json['customer_name']),
      customerMobile: _parseString(json['customer_mobile']),
      deliveryAddress: _parseString(json['delivery_address']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      amountTotal: (json['amount_total'] as num?)?.toDouble(),
      paymentMethod: _parseString(json['payment_method']),
      deliveryStatus: _parseString(json['delivery_status']),
      otpVerified: json['otp_verified'] as bool?,
      otpRequired: json['otp_required'] as bool?,
      podUploaded: json['pod_uploaded'] as bool?,
      podRequired: json['pod_required'] as bool?,
      deliveryOtp: _parseString(json['delivery_otp']),
      items: json['items'] != null
          ? (json['items'] as List).map((e) => TripOrderItem.fromJson(e as Map<String, dynamic>)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_name'] = orderName;
    data['customer_name'] = customerName;
    data['customer_mobile'] = customerMobile;
    data['delivery_address'] = deliveryAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['amount_total'] = amountTotal;
    data['payment_method'] = paymentMethod;
    data['delivery_status'] = deliveryStatus;
    data['otp_verified'] = otpVerified;
    data['otp_required'] = otpRequired;
    data['pod_uploaded'] = podUploaded;
    data['pod_required'] = podRequired;
    data['delivery_otp'] = deliveryOtp;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TripOrderItem {
  final int? productId;
  final String? productName;
  final double? quantity;
  final double? unitPrice;
  final double? subtotal;

  TripOrderItem({
    this.productId,
    this.productName,
    this.quantity,
    this.unitPrice,
    this.subtotal,
  });

  factory TripOrderItem.fromJson(Map<String, dynamic> json) {
    return TripOrderItem(
      productId: json['product_id'] as int?,
      productName: _parseString(json['product_name']),
      quantity: (json['quantity'] as num?)?.toDouble(),
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['unit_price'] = unitPrice;
    data['subtotal'] = subtotal;
    return data;
  }
}
