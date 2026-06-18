// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/bottom_bar.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';

// class CommonBackToHomeButton extends StatefulWidget {
//   const CommonBackToHomeButton({super.key});

//   @override
//   State<CommonBackToHomeButton> createState() => _CommonBackToHomeButtonState();
// }

// class _CommonBackToHomeButtonState extends State<CommonBackToHomeButton> {
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: () async {
//         Navigator.of(context).popUntil((route) {
//           return route.settings.name == '/bottomBar';
//         });
//       },
//       child: Container(
//         height: h * 0.060,
//         width: w / 2.2,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(35)),
//           color: blackColor,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(CupertinoIcons.home, color: Colors.white),
//             (w * 0.01).addWSpace(),
//             AppString.backToHome
//                 .regularRobotoTextStyle(fontSize: 16, fontColor: Colors.white)
//           ],
//         ),
//       ),
//     );
//   }
// }
