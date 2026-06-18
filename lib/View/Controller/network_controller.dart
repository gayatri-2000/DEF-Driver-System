// import 'dart:async';
// import 'dart:developer';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class NetworkController extends GetxController {
//   bool isResult = false;
//   late ConnectivityResult result;
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> connectivitySubscription;

//   void changeBool(bool value) {
//     isResult = value;
//     update();
//   }

//   void changeResult(var value) {
//     result = value;
//     update();
//   }

//   Future<void> initConnectivity() async {
//     late ConnectivityResult result;
//     try {
//       result = await _connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       log('Couldn\'t check connectivity status', error: e);
//       return;
//     }
//     return _updateConnectionStatus(result);
//   }

//   Future<void> _updateConnectionStatus(ConnectivityResult result) async {
//     changeResult(result);
//     log("ConnectivityResult.none----${ConnectivityResult.none}");

//     if (result == ConnectivityResult.none) {
//       log("RESULT----HELLO$result");
//       changeBool(true);
//       log("ISRESULT----$isResult");
//     } else {
//       changeBool(false);
//     }
//   }

//   Future<void> checkConnectivity() async {
//     await initConnectivity().then((value) async {
//       connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//       log("ISRESULT---$isResult");
//     });
//   }
// }
