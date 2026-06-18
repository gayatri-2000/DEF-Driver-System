class UploadPodResponseModel {
  final String? status;
  final String? message;
  final int? orderId;
  final String? orderName;

  UploadPodResponseModel({
    this.status,
    this.message,
    this.orderId,
    this.orderName,
  });

  factory UploadPodResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadPodResponseModel(
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
