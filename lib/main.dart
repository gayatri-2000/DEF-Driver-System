import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Api/Services/one_signal_service.dart';
import 'View/Screen/Login/login_screen.dart';
import 'View/Screen/bottom_bar.dart';
import 'View/Controller/auth_controller.dart';
import 'View/Controller/trip_controller.dart';
import 'View/Controller/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignalService.initialize();

  // Pre-initialize controllers
  final authController = Get.put(AuthController());
  await authController.checkLogin();

  Get.put(TripController());
  Get.put(NotificationController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return GetMaterialApp(
      title: 'Dreamwarez DEF DMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1167EE)),
        useMaterial3: true,
        fontFamily: 'Barlow', // Setting consistent typography fallback
      ),
      home: authController.isLoggedIn ? const AppBottomBar() : const LoginScreen(),
    );
  }
}
