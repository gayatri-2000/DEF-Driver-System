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
      status: json['status'] as String?,
      message: json['message'] as String?,
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
      orderId: json['order_id'] as int?,
      orderName: json['order_name'] as String?,
      status: json['status'] as String?,
      deliveredDate: json['delivered_date'] as String?,
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
