import '../Utils/api_parser.dart';

class CompleteOrderResponseModel {
  final String? status;
  final String? message;
  final CompleteOrderDetails? order;

  CompleteOrderResponseModel({
    this.status,
    this.message,
    this.order,
  });

  factory CompleteOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return CompleteOrderResponseModel(
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
      order: json['order'] != null
          ? CompleteOrderDetails.fromJson(json['order'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class CompleteOrderDetails {
  final int? orderId;
  final String? orderName;
  final String? status;
  final String? deliveredDate;

  CompleteOrderDetails({
    this.orderId,
    this.orderName,
    this.status,
    this.deliveredDate,
  });

  factory CompleteOrderDetails.fromJson(Map<String, dynamic> json) {
    return CompleteOrderDetails(
      orderId: ApiParser.parseInt(json['order_id']),
      orderName: ApiParser.parseString(json['order_name']),
      status: ApiParser.parseString(json['status']),
      deliveredDate: ApiParser.parseString(json['delivered_date']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_name'] = orderName;
    data['status'] = status;
    data['delivered_date'] = deliveredDate;
    return data;
  }
}
