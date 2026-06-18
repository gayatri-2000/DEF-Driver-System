import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'View/Screen/Login/login_screen.dart';
import 'View/Screen/bottom_bar.dart';
import 'View/Controller/auth_controller.dart';
import 'View/Controller/trip_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-initialize controllers
  final authController = Get.put(AuthController());
  await authController.checkLogin();
  
  Get.put(TripController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return GetMaterialApp(
      title: 'DEF Driver System',
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
