import 'dart:developer';
import 'package:def_driver_system/Api/ResponseModel/login_response_model.dart';
import 'package:def_driver_system/Api/Services/api_service.dart';
import 'package:def_driver_system/Api/Services/base_service.dart';

class AuthRepo {
  final APIService _apiService = APIService();

  Future<LoginResponseModel> login({
    required String username,
    required String password,
    required String db,
  }) async {
    final Map<String, dynamic> body = {
      'db': db,
      'login': username,
      'password': password,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.loginAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("AuthRepo Login Response: $response");
    return LoginResponseModel.fromJson(response);
  }

  Future<Map<String, dynamic>> sendOtp({required String mobile}) async {
    final Map<String, dynamic> body = {
      'mobile': mobile,
    };
    final response = await _apiService.getResponse(
      url: ApiRouts.sendOtpAPI,
      apiType: APIType.aPost,
      body: body,
    );
    log("AuthRepo SendOtp Response: $response");
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resetPassword({
    required String mobile,
    required String otp,
    required String newPassword,
  }) async {
    final Map<String, dynamic> body = {
      'mobile': mobile,
      'otp': otp,
      'new_password': newPassword,
    };
    final response = await _apiService.getResponse(
      url: ApiRouts.resetPasswordAPI,
      apiType: APIType.aPost,
      body: body,
    );
    log("AuthRepo ResetPassword Response: $response");
    return response as Map<String, dynamic>;
  }
}
