// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/AuthScreen/auth_controller.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Profile/profile_screen_controller.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/text_field.dart';
// import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

// class UpdatePasswordScreen extends StatefulWidget {
//   const UpdatePasswordScreen({super.key});

//   @override
//   State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
// }

// class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
//   ProfileScreenController profileScreenController = Get.find();
//   AuthController authController = Get.put(AuthController());

//   @override
//   void dispose() {
//     profileScreenController.oldPasswordController.clear();
//     profileScreenController.newPasswordController.clear();
//     profileScreenController.reEnterNewPasswordController.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return Container(
//       color: backGroundColor,
//       child: Scaffold(
//         appBar: AppBarWidget(
//             leading: true,
//             centerTitle: false,
//             title: AppString.changePassword.boldRobotoTextStyle(fontSize: 20)),
//         backgroundColor: backGroundColor,
//         body: GetBuilder<ProfileScreenController>(
//           builder: (controller) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     vertical: h * 0.02, horizontal: w * 0.06),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     (h * 0.03).addHSpace(),
//                     AppString.oldPassword
//                         .boldRobotoTextStyle(fontSize: 18)
//                         .paddingOnly(bottom: h * 0.01),
//                     passwordTextField(controller.oldPasswordController, w, h),
//                     (h * 0.03).addHSpace(),
//                     AppString.newPassword
//                         .boldRobotoTextStyle(fontSize: 18)
//                         .paddingOnly(bottom: h * 0.01),
//                     passwordObsecureTextField(
//                         controller.newPasswordController, w, h, context),
//                     (h * 0.03).addHSpace(),
//                     AppString.reEnterNewPassword
//                         .boldRobotoTextStyle(fontSize: 18)
//                         .paddingOnly(bottom: h * 0.01),
//                     passwordTextField(
//                         controller.reEnterNewPasswordController, w, h),
//                     (h * 0.1).addHSpace(),
//                     Center(
//                       child: controller.updatePasswordResponse.status ==
//                                   Status.LOADING ||
//                               authController.loginApiResponse.status ==
//                                   Status.LOADING
//                           ? showCircular()
//                           : MaterialButton(
//                               minWidth: w * 0.6,
//                               onPressed: () {
//                                 controller.checkValidPassword();
//                               },
//                               color: Colors.black,
//                               height: Responsive.isDesktop(context)
//                                   ? h * 0.078
//                                   : h * 0.058,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: AppString.update.boldRobotoTextStyle(
//                                   fontSize: 16, fontColor: backGroundColor),
//                             ),
//                     ),
//                     (h * 0.1).addHSpace(),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// /// PASSWORD TEXTFIELD

// Widget passwordTextField(TextEditingController controller, double w, double h) {
//   return TextFormField(
//     readOnly: false,
//     controller: controller,
//     style: textFieldTextStyle,
//     cursorWidth: 2,
//     // minLines: 5,
//     // maxLines: 5,
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: containerColor,
//       hintText: "Enter Password",
//       hintStyle: textFieldHintTextStyle,
//       contentPadding:
//           EdgeInsets.symmetric(horizontal: w * 0.045).copyWith(top: h * 0.03),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(
//           color: Colors.grey.shade600,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(
//           color: Colors.grey.shade600,
//         ),
//       ),
//     ),
//   );
// }

// /// Obsecure TEXTFIELD

// Widget passwordObsecureTextField(
//     TextEditingController controller, double w, double h, context) {
//   return GetBuilder<AuthController>(
//     builder: (authController) {
//       return TextFormField(
//         readOnly: false,
//         controller: controller,
//         style: textFieldTextStyle,
//         cursorWidth: 2,
//         obscureText: !authController.isVisible,
//         decoration: InputDecoration(
//           suffixIcon: GestureDetector(
//             onTap: () {
//               authController.isObSecure();
//             },
//             child: Icon(
//               authController.isVisible
//                   ? Icons.remove_red_eye_outlined
//                   : Icons.visibility_off_outlined,
//               color: Colors.black,
//               size: Responsive.isDesktop(context)
//                   ? h * 0.04
//                   : Responsive.isTablet(context)
//                       ? h * 0.031
//                       : h * 0.025,
//             ).paddingOnly(right: Responsive.isDesktop(context) ? w * 0.02 : 0),
//           ),
//           filled: true,
//           fillColor: containerColor,
//           hintText: "Enter Password",
//           hintStyle: textFieldHintTextStyle,
//           contentPadding: EdgeInsets.symmetric(horizontal: w * 0.045)
//               .copyWith(top: h * 0.03),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(
//               color: Colors.grey.shade600,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
