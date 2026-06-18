import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:def_driver_system/View/Screen/Login/login_screen.dart';
import 'package:def_driver_system/View/Utils/app_layout.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const isLogin = "isLogin";
  static const isAdmin = "isAdmin";
  static const userLoginData = "userLoginData";
  static const sessionId = "sessionId";
  static const userType = "userType";
  static const userId = "userId";
  static const userPassword = "userPassword";
  static const userName = "userName";
  static const profileImage = "profileImage";

  logOut() async {
    await _preferences?.clear();
    Get.offAll(() => const LoginScreen());
    successSnackBar("Success", "You've been logged out");
  }

  Future<bool?> putString(String key, String value) async {
    return _preferences?.setString(key, value);
  }

  String? getString(String key, {String defValue = ""}) {
    return _preferences?.getString(key) ?? defValue;
  }

  Future<bool?> putInt(String key, int value) async {
    return _preferences?.setInt(key, value);
  }

  int? getInt(String key, {int defValue = 0}) {
    return _preferences?.getInt(key) ?? defValue;
  }

  Future<bool?> putDouble(String key, double value) async {
    return _preferences?.setDouble(key, value);
  }

  double getDouble(String key, {double defValue = 0.0}) {
    return _preferences?.getDouble(key) ?? defValue;
  }

  Future<bool?> putBool(String key, bool value) async {
    return _preferences?.setBool(key, value);
  }

  bool? getBool(String key, {bool defValue = false}) {
    return _preferences?.getBool(key) ?? defValue;
  }

  Future<bool?> removePreference(String key) async {
    return _preferences?.remove(key);
  }
}
