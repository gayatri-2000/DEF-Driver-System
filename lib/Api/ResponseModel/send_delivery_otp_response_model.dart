class SendDeliveryOtpResponseModel {
  final String? status;
  final String? message;
  final int? orderId;
  final String? orderName;

  SendDeliveryOtpResponseModel({
    this.status,
    this.message,
    this.orderId,
    this.orderName,
  });

  factory SendDeliveryOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return SendDeliveryOtpResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      orderId: json['order_id'] as int?,
      orderName: json['order_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['order_id'] = orderId;
    data['order_name'] = orderName;
    return data;
  }
}
