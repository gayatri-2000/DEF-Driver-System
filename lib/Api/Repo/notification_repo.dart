// import 'dart:developer';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/notification_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/Services/api_service.dart';
// import 'package:venkatesh_buildcon_app/Api/Services/base_service.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';

// class NotificationRepo {
//   Map<String, String> header1 = {
//     'Content-Type': 'application/json',
//     'Cookie':
//         'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
//   };

//   /// GET NOTIFICATION PROJECT DETAILS ::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> getNotificationRepo() async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.notification,
//       apiType: APIType.aPost,
//       body: {
//         "id": int.parse(preferences.getString(SharedPreference.userId) ?? "0")
//       },
//       header: header1,
//     );

//     log('notificationResModel --- response>> $response');

//     NotificationResModel notificationResModel =
//         NotificationResModel.fromJson(response);

//     log('notificationResModel --- response>> $response');

//     return notificationResModel;
//   }
// }
