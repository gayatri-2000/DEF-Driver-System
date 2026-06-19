import 'dart:developer';
import 'package:get/get.dart';
import '../../Api/Repo/auth_repo.dart';
import '../../Api/Repo/mock_data.dart';
import '../../Api/Services/base_service.dart';
import '../../Api/Services/one_signal_service.dart';
import '../../Api/ResponseModel/login_response_model.dart';
import '../../View/Constant/shared_prefs.dart';
import '../../View/Utils/app_layout.dart';

class AuthController extends GetxController {
  bool isLoggedIn = false;
  Driver? currentDriver;
  final AuthRepo _authRepo = AuthRepo();

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await preferences.init();
    isLoggedIn = preferences.getBool(SharedPreference.isLogin) ?? false;
    if (isLoggedIn) {
      final String uid = preferences.getString(SharedPreference.userId) ?? "";
      final String name = preferences.getString(SharedPreference.userName) ?? "";
      final String email = preferences.getString(SharedPreference.userPassword) ?? ""; // username/email field

      currentDriver = Driver(
        id: uid.isNotEmpty ? uid : "DRV12345",
        name: name.isNotEmpty ? name : "Rajesh Kumar",
        email: email.isNotEmpty ? email : "rajesh.kumar@defdelivery.com",
        phone: "+91 98765 43210",
        baseLocation: "Chennai Plant",
        rating: 4.8,
        totalDeliveries: 2847,
        onTimeRate: 98.0,
        thisMonthDeliveries: 156,
        vehicleReg: "TN 01 AB 1234",
        vehicleLicense: "TN-1234567890",
      );
    }
    update();
  }

  Future<bool> login(String phone, String pin) async {
    try {
      await preferences.init();
      final String db = ApiRouts.databaseName;
      final String? playerId = await OneSignalService.getPlayerId();

      LoginResponseModel loginRes = await _authRepo.login(
        username: phone,
        password: pin,
        db: db,
        playerId: playerId,
      );

      if (loginRes.uid != null) {
        // Validate user type: must be driver
        if (loginRes.userType != 'driver') {
          errorSnackBar(
            "Access Denied",
            "This account is not registered as a driver (${loginRes.userType}).",
          );
          return false;
        }

        await OneSignalService.loginUser(loginRes.uid.toString());

        // Save session details
        await preferences.putBool(SharedPreference.isLogin, true);
        await preferences.putString(SharedPreference.userId, loginRes.uid.toString());
        await preferences.putString(SharedPreference.userName, loginRes.name ?? "");
        await preferences.putString(SharedPreference.userPassword, loginRes.username ?? "");
        await preferences.putString(SharedPreference.profileImage, loginRes.profileImage ?? "");

        // Save sid if returned in JSON payload and no session ID is currently saved
        final String currentSession = preferences.getString(SharedPreference.sessionId) ?? "";
        if (currentSession.isEmpty && loginRes.session?.sid != null) {
          await preferences.putString(SharedPreference.sessionId, loginRes.session!.sid!);
        }

        isLoggedIn = true;
        currentDriver = Driver(
          id: loginRes.uid.toString(),
          name: loginRes.name ?? "Rajesh Kumar",
          email: loginRes.username ?? "rajesh.kumar@defdelivery.com",
          phone: phone,
          baseLocation: "Chennai Plant",
          rating: 4.8,
          totalDeliveries: 2847,
          onTimeRate: 98.0,
          thisMonthDeliveries: 156,
          vehicleReg: "TN 01 AB 1234",
          vehicleLicense: "TN-1234567890",
        );

        update();
        successSnackBar("Success", "Login Successful. Welcome back, ${loginRes.name}!");
        return true;
      } else {
        String errMsg = loginRes.message ?? "Invalid credentials.";
        if (errMsg.toLowerCase().contains("access denied") ||
            errMsg.toLowerCase().contains("wrong login/password") ||
            errMsg.toLowerCase().contains("invalid")) {
          errMsg = "You have entered wrong password";
        }
        errorSnackBar(
          "Login Failed",
          errMsg,
        );
        return false;
      }
    } catch (e) {
      log("AuthController login error: $e");
      String errMsg = e.toString()
          .replaceAll('FetchDataException:', '')
          .replaceAll('UnAuthorized Request:', '')
          .trim();
      if (errMsg.toLowerCase().contains("access denied") ||
          errMsg.toLowerCase().contains("wrong login/password") ||
          errMsg.toLowerCase().contains("unauthorized") ||
          errMsg.toLowerCase().contains("invalid")) {
        errMsg = "You have entered wrong password";
      }
      errorSnackBar(
        "Login Error",
        errMsg,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await preferences.init();
    await OneSignalService.logoutUser();
    await preferences.logOut();
    isLoggedIn = false;
    currentDriver = null;
    update();
  }

  Future<bool> sendOtp(String mobile) async {
    try {
      final res = await _authRepo.sendOtp(mobile: mobile);
      if (res['status'] == 'SUCCESS') {
        successSnackBar("Success", res['message'] ?? "OTP sent successfully to WhatsApp");
        return true;
      } else {
        errorSnackBar("Failed", res['message'] ?? "Failed to send OTP");
        return false;
      }
    } catch (e) {
      log("AuthController sendOtp error: $e");
      errorSnackBar(
        "Error",
        e.toString().replaceAll('FetchDataException:', '').replaceAll('UnAuthorized Request:', ''),
      );
      return false;
    }
  }

  Future<bool> resetPasswordAction({
    required String mobile,
    required String otp,
    required String newPassword,
  }) async {
    log("AuthController: resetPasswordAction called for mobile: $mobile, otp: $otp");
    try {
      final res = await _authRepo.resetPassword(
        mobile: mobile,
        otp: otp,
        newPassword: newPassword,
      );
      log("AuthController: resetPassword response received: $res");
      if (res['status'] == 'SUCCESS') {
        return true;
      } else {
        log("AuthController: Reset password failed with message: ${res['message']}");
        errorSnackBar("Failed", res['message'] ?? "Failed to reset password");
        return false;
      }
    } catch (e) {
      log("AuthController resetPasswordAction error: $e");
      errorSnackBar(
        "Error",
        e.toString().replaceAll('FetchDataException:', '').replaceAll('UnAuthorized Request:', ''),
      );
      return false;
    }
  }
}
