import '../Utils/api_parser.dart';

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
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
      orderId: ApiParser.parseInt(json['order_id']),
      orderName: ApiParser.parseString(json['order_name']),
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
