import 'package:def_driver_system/View/Constant/app_color.dart';
import 'package:flutter/material.dart';


extension SizedExtension on double {
  addHSpace() {
    return SizedBox(height: this);
  }

  addWSpace() {
    return SizedBox(width: this);
  }
}

extension AppDivider on double {
  Widget appDivider({Color? color, double? height}) {
    return Divider(
      thickness: this,
      height: height,
      color: color ?? Colors.white,
    );
  }
}

extension AppValidation on String {
  isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

printData({required dynamic tittle, dynamic val}) {
  debugPrint(tittle + ":-" + val.toString());
}

hideKeyBoard(BuildContext context) {
  return FocusScope.of(context).unfocus();
}

extension RobotoTextStyle on String {
  Widget boldRobotoTextStyle(
      {Color? fontColor,
      double? fontSize,
      TextDecoration? textDecoration,
      TextOverflow? textOverflow,
      int? maxLine,
      TextAlign? textAlign}) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        color: fontColor ?? Colors.black,
        fontSize: fontSize ?? 20,
        fontFamily: 'RethinkSans',
        fontWeight: FontWeight.bold,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }

  Widget regularRobotoTextStyle(
      {Color? fontColor,
      double? fontSize,
      TextDecoration? textDecoration,
      TextOverflow? textOverflow,
      int? maxLine,
      TextAlign? textAlign}) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        color: fontColor ?? Colors.black,
        fontSize: fontSize ?? 12,
        fontFamily: 'RethinkSans',
        fontWeight: FontWeight.normal,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }
}

extension BarlowTextStyle on String {
  Widget semiBoldBarlowTextStyle(
      {Color? fontColor,
      double? fontSize,
      TextDecoration? textDecoration,
      TextOverflow? textOverflow,
      int? maxLine,
      TextAlign? textAlign}) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        color: fontColor ?? Colors.black,
        fontFamily: 'Barlow',
        fontSize: fontSize ?? 18,
        fontWeight: FontWeight.w700,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }

  Widget regularBarlowTextStyle(
      {Color? fontColor,
      double? fontSize,
      TextDecoration? textDecoration,
      TextOverflow? textOverflow,
      TextAlign? textAlign,
      int? maxLine}) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
        color: fontColor ?? Colors.black,
        fontFamily: 'Barlow',
        fontSize: fontSize ?? 12,
        fontWeight: FontWeight.normal,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
      maxLines: maxLine,
    );
  }
}

TextStyle black15Bold = const TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontFamily: 'RethinkSans',
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.none,
);

TextStyle black11Bold = const TextStyle(
  color: Colors.black,
  fontFamily: 'Barlow',
  fontSize: 11,
  fontWeight: FontWeight.normal,
  decoration: TextDecoration.none,
);

const TextStyle textFieldTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'Barlow');

TextStyle textFieldHintTextStyle = TextStyle(
    fontSize: 16,
    color: greyTextColor,
    fontWeight: FontWeight.bold,
    fontFamily: 'Barlow');

extension AppButtonText on String {
  Text buttonTextStyle400(
      {Color? fontColor,
      double? fontSize,
      TextDecoration? textDecoration,
      TextOverflow? textOverflow,
      TextAlign? textAlign}) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w400,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }
}
