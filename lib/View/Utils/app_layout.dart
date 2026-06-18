import 'package:flutter/material.dart';
import 'package:get/get.dart';

successSnackBar(
  String title,
  String message,
) {
  return Get.showSnackbar(
    GetSnackBar(
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xff0C243E), // darkColor
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: 'Barlow',
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xff555555),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Barlow',
        ),
      ),
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Color(0xff25B75F), // greenColor
        size: 26,
      ),
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderWidth: 1.5,
      borderColor: const Color(0xff25B75F).withOpacity(0.3),
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

errorSnackBar(
  String title,
  String error,
) {
  return Get.showSnackbar(
    GetSnackBar(
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xff0C243E), // darkColor
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: 'Barlow',
        ),
      ),
      messageText: Text(
        error,
        style: const TextStyle(
          color: Color(0xff555555),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Barlow',
        ),
      ),
      icon: const Icon(
        Icons.error_rounded,
        color: Color(0xffB8220D), // redColor
        size: 26,
      ),
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderWidth: 1.5,
      borderColor: const Color(0xffB8220D).withOpacity(0.3),
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

showCircular() {
  return const Center(
    child: CircularProgressIndicator(color: Colors.black),
  );
}
