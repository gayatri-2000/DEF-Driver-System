// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
// import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/login_response_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/success_data_res_model.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/AuthScreen/auth_controller.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';

// class ProfileScreenController extends GetxController {
//   TextEditingController oldPasswordController = TextEditingController();
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController reEnterNewPasswordController = TextEditingController();

//   var selectedItem = 0;
//   bool isVisible = false;

//   @override
//   void onInit() {
//     getProfileData();
//     super.onInit();
//   }

//   isObSecure() {
//     isVisible = !isVisible;
//     update();
//   }

//   LoginResponseModel? profileData;
//   getProfileData() {
//     String data = preferences.getString(SharedPreference.userLoginData) ?? "";
//     profileData = LoginResponseModel.fromJson(jsonDecode(data));
//   }

//   checkValidPassword() {
//     hideKeyBoard(Get.overlayContext!);
//     if (oldPasswordController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter old password');
//     } else if (newPasswordController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter new password');
//     } else if (reEnterNewPasswordController.text.isEmpty) {
//       errorSnackBar("Required Field", 'Please enter re enter new password');
//     } else if (oldPasswordController.text.trim() !=
//         preferences.getString(SharedPreference.userPassword).toString()) {
//       errorSnackBar("Error!", 'old password not valid');
//     } else if (newPasswordController.text.trim() !=
//         reEnterNewPasswordController.text.trim()) {
//       errorSnackBar("Error!", 're enter new password are not same');
//     } else {
//       updatePassword();
//     }
//   }

//   /// Update Password
//   ApiResponse _updatePasswordResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get updatePasswordResponse => _updatePasswordResponse;

//   Future<void> updatePassword() async {
//     AuthController authController = Get.put(AuthController());
//     _updatePasswordResponse = ApiResponse.loading(message: 'Loading');
//     update();

//     try {
//       SuccessDataResponseModel successDataResponseModel =
//           await ProjectRepo().changePasswordRepo(
//         body: {
//           "user_id": int.parse(
//               preferences.getString(SharedPreference.userId).toString()),
//           "old_password": oldPasswordController.text.trim(),
//           "new_password": newPasswordController.text.trim(),
//         },
//       );
//       if (successDataResponseModel.status == "SUCCESS" ||
//           successDataResponseModel.status == "success") {
//         WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//           await authController.userLogin(screen: "change_password");
//         });
//         preferences.putString(
//             SharedPreference.userPassword, newPasswordController.text.trim());
//         Get.back();
//         successSnackBar("Success", "Password Changed Successfully");
//       } else {
//         errorSnackBar(
//             "Something Went Wrong", successDataResponseModel.message ?? "");
//       }
//       _updatePasswordResponse = ApiResponse.complete(successDataResponseModel);
//     } catch (e) {
//       _updatePasswordResponse = ApiResponse.error(message: e.toString());
//       log("Update Password Response Error==>$e");
//     }
//     update();
//   }
// }
