import 'dart:developer';
import 'package:def_driver_system/Api/ResponseModel/dashboard_response_model.dart';
import 'package:def_driver_system/Api/Services/api_service.dart';
import 'package:def_driver_system/Api/Services/base_service.dart';

class DashboardRepo {
  final APIService _apiService = APIService();

  Future<DashboardResponseModel> fetchDashboard() async {
    final response = await _apiService.getResponse(
      url: ApiRouts.dashboardAPI,
      apiType: APIType.aGet,
    );

    log("DashboardRepo fetchDashboard Response: $response");
    return DashboardResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
