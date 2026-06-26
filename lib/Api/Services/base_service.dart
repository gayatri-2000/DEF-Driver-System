class ApiRouts {
  static String databaseName = 'def';
  static String base = 'http://168.144.73.80:8069/';
  static String baseUrl = '${base}session/auth';

  /// APIS
  static String loginAPI = '$baseUrl/login';
  static String registerAPI = '$baseUrl/signup';
  static String logOutAPI = '$baseUrl/logout';
  static String changePassword = '$baseUrl/change_password';
  static String sendOtpAPI = '$baseUrl/send/otp';
  static String resetPasswordAPI = '$baseUrl/reset_password';
  static String dashboardAPI = '$baseUrl/api/dashboard';
  static String tripDetailAPI = '$baseUrl/api/driver/trip/detail';
  static String startTripAPI = '$baseUrl/api/driver/start_trip';
  static String driverTripsAPI = '$baseUrl/api/driver/trips';
  static String sendDeliveryOtpAPI = '$baseUrl/api/driver/send_otp';
  static String verifyDeliveryOtpAPI = '$baseUrl/api/driver/verify_otp';
  static String uploadPodAPI = '$baseUrl/api/driver/upload_pod';
  static String uploadSignatureAPI = '$baseUrl/api/driver/upload_signature';
  static String completeOrderAPI = '$baseUrl/api/driver/complete_order';
  static String completeTripAPI = '$baseUrl/api/driver/complete_trip';
  static String tripHistoryAPI = '$baseUrl/api/driver/trip_history';
  static String tripHistoryDetailAPI =
      '$baseUrl/api/driver/trip_history_detail';
  static String notificationAPI = '$baseUrl/api/notification';
  static String orderInstructionsAPI = '$baseUrl/api/order/instructions';
}
