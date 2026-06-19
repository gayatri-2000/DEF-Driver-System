import 'dart:developer';
import 'package:def_driver_system/Api/ResponseModel/notification_response_model.dart';
import 'package:def_driver_system/Api/Services/api_service.dart';
import 'package:def_driver_system/Api/Services/base_service.dart';

class NotificationRepo {
  final APIService _apiService = APIService();

  Future<NotificationResponseModel> getNotifications(int customerId) async {
    final Map<String, dynamic> body = {
      'customer_id': customerId,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.notificationAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("NotificationRepo getNotifications Response: $response");
    return NotificationResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
