// import 'package:flutter/material.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_assets.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';

// class SearchAndFilterRow extends StatelessWidget {
//   final String? hintText;
//   final TextEditingController? controller;
//   final void Function(String)? onChanged;
//   final void Function()? onTap;
//   final bool isFilter;
//   final TextInputType? type;

//   const SearchAndFilterRow({
//     super.key,
//     this.hintText,
//     this.controller,
//     this.onChanged,
//     this.onTap,
//     this.isFilter = true,
//     this.type,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return Row(
//       children: [
//         Expanded(
//           child: SizedBox(
//             height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//             child: TextField(
//               keyboardType: type,
//               onChanged: onChanged,
//               controller: controller,
//               style: textFieldTextStyle,
//               decoration: InputDecoration(
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? w * 0.025 : w * 0.05)
//                         .copyWith(
//                             bottom: Responsive.isDesktop(context) ? h * 0.02 : h * 0.025,
//                             top: Responsive.isDesktop(context) ? h * 0.04 : 0),
//                 hintStyle: textFieldHintTextStyle.copyWith(
//                     fontFamily: 'Barlow', fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black),
//                 hintText: hintText ?? "",
//                 fillColor: containerColor,
//                 filled: true,
//                 suffixIcon: assetImage(AppAssets.searchIcon, scale: 2.5),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Color(0xffE6E6E6)),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Color(0xffE6E6E6)),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         isFilter == true
//             ? GestureDetector(
//                 onTap: onTap,
//                 child: Container(
//                   height: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//                   width: Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
//                   margin: EdgeInsets.only(left: w * 0.03),
//                   decoration: BoxDecoration(
//                     color: containerColor,
//                     border: Border.all(color: const Color(0xffE6E6E6)),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.tune),
//                 ),
//               )
//             : const SizedBox()
//       ],
//     );
//   }
// }
