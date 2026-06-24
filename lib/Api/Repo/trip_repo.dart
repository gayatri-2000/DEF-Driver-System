import 'dart:developer';
import 'package:def_driver_system/Api/ResponseModel/trip_detail_response_model.dart';
import 'package:def_driver_system/Api/ResponseModel/start_trip_response_model.dart';
import 'package:def_driver_system/Api/ResponseModel/driver_trips_response_model.dart';
import 'package:def_driver_system/Api/ResponseModel/trip_history_response_model.dart';
import 'package:def_driver_system/Api/ResponseModel/trip_history_detail_response_model.dart';
import 'package:def_driver_system/Api/ResponseModel/send_delivery_otp_response_model.dart';
import 'package:def_driver_system/Api/ResponseModel/verify_otp_response_model.dart';
import 'package:def_driver_system/Api/ResponseModel/upload_pod_response_model.dart';
import 'package:def_driver_system/Api/ResponseModel/upload_signature_response_model.dart';
import 'package:def_driver_system/Api/ResponseModel/complete_order_response_model.dart';
import 'package:def_driver_system/Api/Services/api_service.dart';
import 'package:def_driver_system/Api/Services/base_service.dart';

class TripRepo {
  final APIService _apiService = APIService();

  Future<TripDetailResponseModel> getTripDetail(int tripId) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'trip_id': tripId,
      },
      'trip_id': tripId,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.tripDetailAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("TripRepo getTripDetail Response: $response");
    return TripDetailResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<StartTripResponseModel> startTrip(int tripId) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'trip_id': tripId,
      },
      'trip_id': tripId,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.startTripAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("TripRepo startTrip Response: $response");
    return StartTripResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<DriverTripsResponseModel> getDriverTrips(String status) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'status': status,
      },
      'status': status,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.driverTripsAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("TripRepo getDriverTrips Response: $response");
    return DriverTripsResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<SendDeliveryOtpResponseModel> sendDeliveryOtp(int orderId) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'order_id': orderId,
      },
      'order_id': orderId,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.sendDeliveryOtpAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("TripRepo sendDeliveryOtp Response: $response");
    return SendDeliveryOtpResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<VerifyOtpResponseModel> verifyDeliveryOtp(int orderId, String otp) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'order_id': orderId,
        'otp': otp,
      },
      'order_id': orderId,
      'otp': otp,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.verifyDeliveryOtpAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("TripRepo verifyDeliveryOtp Response: $response");
    return VerifyOtpResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<UploadPodResponseModel> uploadPod(int orderId, String podImage, String podNotes) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'order_id': orderId,
        'pod_image': podImage,
        'pod_notes': podNotes,
      },
      'order_id': orderId,
      'pod_image': podImage,
      'pod_notes': podNotes,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.uploadPodAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("TripRepo uploadPod Response: $response");
    return UploadPodResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<UploadSignatureResponseModel> uploadSignature(int orderId, String signature) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'order_id': orderId,
        'signature': signature,
      },
      'order_id': orderId,
      'signature': signature,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.uploadSignatureAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("TripRepo uploadSignature Response: $response");
    return UploadSignatureResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<CompleteOrderResponseModel> completeOrder(int orderId) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'order_id': orderId,
      },
      'order_id': orderId,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.completeOrderAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("TripRepo completeOrder Response: $response");
    return CompleteOrderResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<TripHistoryResponseModel> getTripHistory() async {
    final response = await _apiService.getResponse(
      url: ApiRouts.tripHistoryAPI,
      apiType: APIType.aPost,
      body: {
        'jsonrpc': '2.0',
        'params': {},
      },
    );

    log("TripRepo getTripHistory Response: $response");
    return TripHistoryResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<TripHistoryDetailResponseModel> getTripHistoryDetail(int tripId) async {
    final Map<String, dynamic> body = {
      'jsonrpc': '2.0',
      'params': {
        'trip_id': tripId,
      },
      'trip_id': tripId,
    };

    final response = await _apiService.getResponse(
      url: ApiRouts.tripHistoryDetailAPI,
      apiType: APIType.aPost,
      body: body,
    );

    log("TripRepo getTripHistoryDetail Response: $response");
    return TripHistoryDetailResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
