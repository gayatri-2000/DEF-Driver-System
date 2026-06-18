// import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
// import 'package:flutter/services.dart';
// import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';

// class AppTextField extends StatelessWidget {
//   final String hintText;
//   final TextEditingController controller;
//   final Widget? icon;
//   final bool obscure;
//   final TextInputType? inputType;
//   final int? maxLength;
//   final double? width;
//   final double? widthContainer;
//   final Function(String)? onChanged;
//   final Function()? onTap;
//   final bool isMobile;
//   final bool? readOnly;

//   const AppTextField({
//     super.key,
//     required this.hintText,
//     required this.controller,
//     this.icon,
//     this.obscure = false,
//     this.inputType,
//     this.maxLength,
//     this.width,
//     this.widthContainer,
//     this.onChanged,
//     this.isMobile = false,
//     this.readOnly,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;

//     return Container(
//       height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//       width: w * 1,
//       margin: EdgeInsets.only(top: h * 0.008),
//       decoration: BoxDecoration(
//         color: textFieldColor,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             offset: const Offset(-1, -1),
//             blurRadius: 2,
//             color: Colors.grey.shade200,
//            // inset: true,
//           ),
//           BoxShadow(
//             offset: const Offset(1, 1),
//             blurRadius: 2,
//             color: Colors.grey.shade200,
//             //inset: true,
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             alignment: Alignment.topCenter,
//             width: widthContainer ?? w * 0.69,
//             child: Center(
//               child: TextField(
//                 onTap: onTap,
//                 readOnly: readOnly ?? false,
//                 inputFormatters:
//                     isMobile ? [LengthLimitingTextInputFormatter(10)] : null,
//                 onChanged: onChanged,
//                 obscureText: obscure,
//                 maxLength: maxLength,
//                 keyboardType: inputType,
//                 controller: controller,
//                 style: textFieldTextStyle,
//                 cursorWidth: 2,
//                 decoration: InputDecoration(
//                     counterText: "",
//                     hintText: hintText,
//                     hintStyle: textFieldHintTextStyle,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: Responsive.isDesktop(context)
//                           ? w * 0.025
//                           : Responsive.isTablet(context)
//                               ? w * 0.033
//                               : w * 0.045,
//                     ),
//                     enabledBorder: InputBorder.none,
//                     focusedBorder: InputBorder.none),
//               ),
//             ),
//           ),
//           SizedBox(width: width ?? h * 0.06845, child: icon!)
//         ],
//       ),
//     );
//   }
// }

// class InnerShadowContainer extends StatelessWidget {
//   final Widget? child;
//   final double? radius;

//   const InnerShadowContainer({
//     super.key,
//     this.child,
//     this.radius,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;

//     return Container(
//       height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//       width: w * 1,
//       margin: EdgeInsets.only(top: h * 0.008),
//       decoration: BoxDecoration(
//         color: textFieldColor,


//         borderRadius: BorderRadius.circular(radius ?? 15),
//         boxShadow: [
//           BoxShadow(
//             offset: const Offset(-1, -1),
//             blurRadius: 2,
//             color: Colors.grey.shade200,
//            // inset: true,
//           ),
//           BoxShadow(
//             offset: const Offset(1, 1),
//             blurRadius: 2,
//             color: Colors.grey.shade200,
//           //  inset: true,
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
