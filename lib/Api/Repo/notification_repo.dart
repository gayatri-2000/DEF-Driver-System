import 'dart:developer';
import 'package:def_driver_system/Api/ResponseModel/notification_response_model.dart';
import 'package:def_driver_system/Api/Services/api_service.dart';
import 'package:def_driver_system/Api/Services/base_service.dart';

class NotificationRepo {
  final APIService _apiService = APIService();

  Future<NotificationResponseModel> getNotifications(int driverId) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'driver_id': driverId,
        'customer_id': driverId,
      },
      'driver_id': driverId, // For the new backend version
      'customer_id': driverId, // For the old backend version
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.notificationAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("NotificationRepo getNotifications Response: $response");

    if (response is Map<String, dynamic>) {
      if (response.containsKey('error')) {
        final errorObj = response['error'] as Map<String, dynamic>;
        final msg = errorObj['message'] ?? 'Odoo JSON-RPC Error';
        return NotificationResponseModel(
          status: 'ERROR',
          message: msg,
          notifications: [],
        );
      }

      final targetData = response.containsKey('result')
          ? response['result'] as Map<String, dynamic>
          : response;

      return NotificationResponseModel.fromJson(targetData);
    }

    return NotificationResponseModel(
      status: 'ERROR',
      message: 'Invalid response format',
      notifications: [],
    );
  }
}
