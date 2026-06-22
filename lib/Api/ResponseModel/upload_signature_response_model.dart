import '../Utils/api_parser.dart';

class UploadSignatureResponseModel {
  final String? status;
  final String? message;

  UploadSignatureResponseModel({
    this.status,
    this.message,
  });

  factory UploadSignatureResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadSignatureResponseModel(
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
