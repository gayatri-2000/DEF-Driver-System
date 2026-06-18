// import 'package:def_driver_system/View/Constant/app_color.dart';
// import 'package:flutter/material.dart';


// class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
//   final List<Widget>? action;
//   final bool centerTitle;
//   final Widget? title;
//   final Widget? leadingIcon;
//   final bool? leading;
//   final Color? color;
//   final void Function()? onPressed;
//   // final double? elevation;

//   const AppBarWidget({
//     super.key,
//     this.action,
//     this.centerTitle = true,
//     this.leading,
//     this.title,
//     this.color,
//     this.leadingIcon,
//     this.onPressed,
//     // this.elevation,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     return AppBar(
//       actions: action,
//       backgroundColor: color ?? backGroundColor,
//       elevation: 2.2,
//       centerTitle: centerTitle,
//       title: title,
//       titleSpacing: 0,
//       leadingWidth: leading == false ? w * 0.06 : w * 0.15,
//       toolbarHeight: Get.height * 0.065,
//       leading: leading == false
//           ? Container()
//           : leadingIcon ??
//               IconButton(
//                 onPressed: onPressed ??
//                     () {
//                       Get.back();
//                     },
//                 icon: Padding(
//                   padding: EdgeInsets.only(left: Responsive.isTablet(context) ? w * 0.02 : w * 0.03),
//                   child: const Icon(Icons.arrow_back_ios, size: 22, color: Colors.black),
//                 ),
//               ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(Get.height * 0.065);
// }
