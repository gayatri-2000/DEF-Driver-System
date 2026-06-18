// import 'dart:convert';
// import 'dart:developer';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/approver_close_nc_response_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/fetch_allnc_data_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_activity_checklist_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_activity_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_activity_type_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_close_state_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_flat_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_floor_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_project_responsible_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_tower_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/nc_routing_through_notification_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/nc_submit_button_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/checklist_as_per_type_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/checklist_data_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/checklist_type_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_by_app_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checkpoint_details_by_activity_type_id.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_flat_data_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_flat_floor_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_floor_data_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_material_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_tower_checklist_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/material_inspection_response_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/project_details_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/project_screen_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/success_data_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/Services/api_service.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
// import '../Services/base_service.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/generate_approver_reject_nc_model.dart';

// class ProjectRepo {
//   Map<String, String> header = {
//     'Cookie':
//         'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
//   };
//   Map<String, String> header1 = {
//     'Content-Type': 'application/json',
//     'Cookie':
//         'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
//   };

//   /// GET PROJECT ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> getAssignedProjectRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getAssignedProject,
//       apiType: APIType.aPost,
//       body: {},
//       header: header,
//     );

//     log('projectScreenResponseModel --- response>> $response');

//     AssignedProjectResponseModel projectScreenResponseModel =
//         AssignedProjectResponseModel.fromJson(response);

//     log('projectScreenResponseModel --- response>> $response');

//     return projectScreenResponseModel;
//   }

//   /// GET PROJECT DETAILS ::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> projectDetailsRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.projectDetails,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('projectDetailsResponseModel --- response>> $response');

//     ProjectDetailsResponseModel projectDetailsResponseModel =
//         ProjectDetailsResponseModel.fromJson(response);

//     log('projectDetailsResponseModel --- response>> $response');

//     return projectDetailsResponseModel;
//   }

//   /// GET TOWER INFO :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> towerInfoChecklistRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.towerInfoCheckList,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('getTowerInfoChecklistResponseModel --- response>> $response');

//     GetTowerInfoChecklistResponseModel getTowerInfoChecklistResponseModel =
//         GetTowerInfoChecklistResponseModel.fromJson(response);

//     log('getTowerInfoChecklistResponseModel --- response>> $response');

//     return getTowerInfoChecklistResponseModel;
//   }

//   /// GET FLAT FLOOR DETAILS :::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> getFlatFloorRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getFlatFloor,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('getFlatFloorDataResponseModel --- response>> $response');

//     GetFlatFloorDataResponseModel getFlatFloorDataResponseModel =
//         GetFlatFloorDataResponseModel.fromJson(response);

//     log('getFlatFloorDataResponseModel --- response>> $response');

//     return getFlatFloorDataResponseModel;
//   }

//   /// GET Material Inspection::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> getMaterialInspection({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getMaterialInspection,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('getMaterialInspectionResponse --- response>> $response');

//     MaterialInspectionResponseModel materialInspectionResponseModel =
//         MaterialInspectionResponseModel.fromJson(response);

//     log('getMaterialInspectionResponse --- response>> $response');

//     return materialInspectionResponseModel;
//   }

//   /// GET FLOOR DETAILS ::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> getFloorRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getFloorActivity,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('getFloorDataResponseModel --- response>> $response');

//     GetFloorDataResponseModel getFloorDataResponseModel =
//         GetFloorDataResponseModel.fromJson(response);

//     log('getFloorDataResponseModel --- response>> $response');

//     return getFloorDataResponseModel;
//   }

//   /// GET FLAT DETAILS :::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> getFlatRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getFlatActivity,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('getFlatDataResponseModel --- response>> $response');

//     GetFlatDataResponseModel getFlatDataResponseModel =
//         GetFlatDataResponseModel.fromJson(response);

//     log('getFlatDataResponseModel --- response>> $response');

//     return getFlatDataResponseModel;
//   }

//   /// GET ACTIVITY CHECKLIST :::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> getActivityChecklistRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getCheckListByActivity,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('getActivityChecklistResponseModel --- response>> $response');

//     ChecklistByActivityResponseModel getActivityChecklistResponseModel =
//         ChecklistByActivityResponseModel.fromJson(response);

//     log('getActivityChecklistResponseModel --- response>> $response');

//     return getActivityChecklistResponseModel;
//   }

//   ///// Activity details for notification

//   Future<dynamic> getActivitydetailsfornotificationRepo(
//       {Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.projectChecklistByAc,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     //   log('getActivityChecklistResponseModel --- response>> $response');

//     //   ChecklistByActivityResponseModel getActivityChecklistResponseModel =
//     //       ChecklistByActivityResponseModel.fromJson(response);

//     //   log('getActivityChecklistResponseModel --- response>> $response');

//     //   return getActivityChecklistResponseModel;
//     // }

//     log('getCheckPointDetailsByActivityTypeId --- response>> $response');

//     GetCheckPointDetailsByActivityTypeId getCheckPointDetailsByActivityTypeId =
//         GetCheckPointDetailsByActivityTypeId.fromJson(response);

//     log('getCheckPointDetailsByActivityTypeId --- response>> $response');

//     return getCheckPointDetailsByActivityTypeId;
//   }

//   /// GET Material Inspection Check List :::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> getMaterialInspectionCheckList() async {
//     var response = await APIService().getResponse(
//         url: ApiRouts.getMaterialInspectionCheckList,
//         apiType: APIType.aPost,
//         header: header1,
//         body: {});

//     log('getMaterialInspectionCheckList --- response>> $response');

//     MaterialInspectionPointsModel getMaterialInspectionCheckList =
//         MaterialInspectionPointsModel.fromJson(response);

//     log('getMaterialInspectionCheckList --- response>> $response');

//     return getMaterialInspectionCheckList;
//   }

//   /// Create Material Inspection :::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> createMaterialInspection({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.createMaterialInspection,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('createMaterialInspection --- response>> $response');
//     SuccessDataResponseModel successDataResponseModel =
//         SuccessDataResponseModel.fromJson(response);
//     log('createMaterialInspection --- response>> $response');
//     return successDataResponseModel;
//   }

//   /// Delete Material Inspection :::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> deleteMaterialInspection({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.deleteMaterialInspection,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('deleteMaterialInspection --- response>> $response');
//     SuccessDataResponseModel successDataResponseModel =
//         SuccessDataResponseModel.fromJson(response);
//     log('deleteMaterialInspection --- response>> $response');
//     return successDataResponseModel;
//   }

//   /// Replicate Material Inspection :::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> replicateMaterialInspection(
//       {Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.replicateMaterialInspection,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('replicateMaterialInspection --- response>> $response');
//     SuccessDataResponseModel successDataResponseModel =
//         SuccessDataResponseModel.fromJson(response);
//     log('replicateMaterialInspection --- response>> $response');
//     return successDataResponseModel;
//   }

//   /// Update Material inspection ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//   // Future<dynamic> updateMaterialInspection({Map<String, dynamic>? body}) async {
//   //   var response = await APIService().getResponse(
//   //     url: ApiRouts.updateMaterialInspection,
//   //     apiType: APIType.aPost,
//   //     body: body,
//   //     header: header1,
//   //   );
//   //
//   //   log('updateMaterialInspection --- response>> $response');
//   //   SuccessDataResponseModel successDataResponseModel =
//   //       SuccessDataResponseModel.fromJson(response);
//   //   log('updateMaterialInspection --- response>> $response');
//   //   return successDataResponseModel;
//   // }

//   /// UPLOAD DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> updateChecklistRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: preferences.getString(SharedPreference.userType) == "checker"
//           ? ApiRouts.updateCheckerData
//           : preferences.getString(SharedPreference.userType) == "approver"
//               ? ApiRouts.updateApproverData
//               : ApiRouts.updateMakerData,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('successDataResponseModel --- response>> $response');

//     SuccessDataResponseModel successDataResponseModel =
//         SuccessDataResponseModel.fromJson(response);

//     log('successDataResponseModel --- response>> $response');

//     return successDataResponseModel;
//   }

//   /// REJECT DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> rejectChecklistRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: preferences.getString(SharedPreference.userType) == "checker"
//           ? ApiRouts.rejectMakerData
//           : ApiRouts.rejectCheckerData,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('successDataResponseModel --- response>> $response');

//     SuccessDataResponseModel successDataResponseModel =
//         SuccessDataResponseModel.fromJson(response);

//     log('successDataResponseModel --- response>> $response');

//     return successDataResponseModel;
//   }

//   /// GET CHECKLIST BY ACTIVITY_TYPE_ID DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> getChecklistByActivityTypeId(
//       {Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.projectChecklistByAc,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('getCheckPointDetailsByActivityTypeId --- response>> $response');

//     GetCheckPointDetailsByActivityTypeId getCheckPointDetailsByActivityTypeId =
//         GetCheckPointDetailsByActivityTypeId.fromJson(response);

//     log('getCheckPointDetailsByActivityTypeId --- response>> $response');

//     return getCheckPointDetailsByActivityTypeId;
//   }

//   /// DUPLICATE ACTIVITY REPO ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> duplicateActivityRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.duplicateActivity,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('duplicateActivityRepo --- response>> $response');

//     SuccessDataResponseModel duplicateActivityRepo =
//         SuccessDataResponseModel.fromJson(response);

//     log('duplicateActivityRepo --- response>> $response');

//     return duplicateActivityRepo;
//   }

//   /// DELETE ACTIVITY REPO ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> deleteActivityRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.deleteActivity,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('duplicateActivityRepo --- response>> $response');

//     SuccessDataResponseModel duplicateActivityRepo =
//         SuccessDataResponseModel.fromJson(response);

//     log('duplicateActivityRepo --- response>> $response');

//     return duplicateActivityRepo;
//   }

//   /// MATERIAL INSPECTION DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> updateMaterialRepo({Map<String, dynamic>? body}) async {
//     log('body----------updateMaterialRepo- ${body}');

//     var response = await APIService().getResponse(
//       url: preferences.getString(SharedPreference.userType) == "checker"
//           ? ApiRouts.updateChecker
//           : preferences.getString(SharedPreference.userType) == "approver"
//               ? ApiRouts.updateApprover
//               : ApiRouts.updateMaker,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );
//     log('successDataResponseModel --- response>> $response');
//     SuccessDataResponseModel successDataResponseModel =
//         SuccessDataResponseModel.fromJson(response);
//     log('successDataResponseModel --- response>> $response');
//     return successDataResponseModel;
//   }

//   /// REJECT
//   Future<dynamic> rejectMakerRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: preferences.getString(SharedPreference.userType) == "checker"
//           ? ApiRouts.rejectChecker
//           : ApiRouts.rejectApprover,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('successDataResponseModel --- response>> $response');

//     SuccessDataResponseModel successDataResponseModel =
//         SuccessDataResponseModel.fromJson(response);

//     log('successDataResponseModel --- response>> $response');

//     return successDataResponseModel;
//   }

//   /// UPLOAD DATA ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> changePasswordRepo({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.changePassword,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('successDataResponseModel --- response changePasswordRepo>> $response');

//     SuccessDataResponseModel successDataResponseModel =
//         SuccessDataResponseModel.fromJson(response);

//     log('successDataResponseModel --- response changePasswordRepo>> $response');

//     return successDataResponseModel;
//   }

// /////////////////////////////////////////////

//   ///basic activity checklist for approver
//   Future<dynamic> getapproveractivityRepo({Map<String, dynamic>? map}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.approveractivity,
//       apiType: APIType.aPost,
//       body: {},
//       header: header1,
//     );

//     log('checklistDataResponseModel --- response>> $response');

//     ChecklistDataResponseModel checklistDataResponseModel =
//         ChecklistDataResponseModel.fromJson(response);

//     log('checklistDataResponseModel --- response>> $response');

//     return checklistDataResponseModel;
//   }

//   /// for activity type
//   Future<dynamic> getapproveractivitytypesRepo(Map<String, dynamic> map) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.approveractivitytypes,
//       apiType: APIType.aPost,
//       body: map,
//       header: header1,
//     );

//     log('activityTypeResponseModel --- response>> $response');

//     ActivityTypeResponseModel activityTypeResponseModel =
//         ActivityTypeResponseModel.fromJson(response);

//     log('activityTypeResponseModel --- response>> $response');

//     return activityTypeResponseModel;
//   }

//   ///checklist after acitvity type

//   Future<dynamic> getapproveractivitytypechecklistRepo(int patn_id,
//       {Map<String, dynamic>? map}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.approveractivitytypechecklist,
//       apiType: APIType.aPost,
//       body: {'patn_id': patn_id},
//       header: header1,
//     );

//     log('activityAsPerTypeResponseModel --- response>> $response');

//     ActivityAsPerTypeResponseModel activityAsPerTypeResponseModel =
//         ActivityAsPerTypeResponseModel.fromJson(response);

//     log('activityAsPerTypeResponseModel --- response>> $response');

//     return activityAsPerTypeResponseModel;
//   }

// ////// generate nc by app
//   /// get project

//   Future<dynamic> ncgetprojectRepo(Map<String, dynamic>? map) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.ncGetProject,
//       apiType: APIType.aPost,
//       body: {},
//       header: header1,
//     );

//     log('generateNcByAppResponseModel --- response>> $response');

//     GenerateNcByAppResponseModel generateNcByAppResponseModel =
//         GenerateNcByAppResponseModel.fromJson(response);

//     log('generateNcByAppResponseModel --- response>> $generateNcByAppResponseModel');

//     return generateNcByAppResponseModel;
//   }

//   ///get tower
//   Future<dynamic> ncgettowerRepo(int project_id,
//       {Map<String, dynamic>? map}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.ncGetTower,
//       apiType: APIType.aPost,
//       body: {'project_id': project_id},
//       header: header1,
//     );

//     log('generateNcByAppTowerResponseModel --- response>> $response');

//     GenerateNcByAppTowerResponseModel generateNcByAppTowerResponseModel =
//         GenerateNcByAppTowerResponseModel.fromJson(response);

//     log('generateNcByAppTowerResponseModel --- response>> $response');

//     return generateNcByAppTowerResponseModel;
//   }

//   ///get floor
//   Future<dynamic> ncgetfloorRepo(int tower_id,
//       {Map<String, dynamic>? map}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.ncGetFloor,
//       apiType: APIType.aPost,
//       body: {'tower_id': tower_id},
//       header: header1,
//     );

//     log('generateNcByAppFloorResponseModel --- response>> $response');

//     GenerateNcByAppFloorResponseModel generateNcByAppFloorResponseModel =
//         GenerateNcByAppFloorResponseModel.fromJson(response);

//     log('generateNcByAppFloorResponseModel --- response>> $response');

//     return generateNcByAppFloorResponseModel;
//   }

// ///// get flat
//   Future<dynamic> ncgetflatRepo(int tower_id,
//       {Map<String, dynamic>? map}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.ncGetFlat,
//       apiType: APIType.aPost,
//       body: {'tower_id': tower_id},
//       header: header1,
//     );

//     log('generateNcByAppFlatResponseModel --- response>> $response');

//     GenerateNcByAppFlatResponseModel generateNcByAppFlatResponseModel =
//         GenerateNcByAppFlatResponseModel.fromJson(response);

//     log('generateNcByAppFlatResponseModel --- response>> $response');

//     return generateNcByAppFlatResponseModel;
//   }

// ////get activity

//   Future<dynamic> ncgetactivityRepo(
//       int flat_id, int floor_id, int tower_id, int project_id,
//       {Map<String, dynamic>? map}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.ncGetActivity,
//       apiType: APIType.aPost,
//       body: {
//         "flat_id": flat_id,
//         "floor_id": floor_id,
//         "tower_id": tower_id,
//         "project_id": project_id,
//       },
//       header: header1,
//     );

//     log('generateNcByAppActivityResponseModel --- response>> $response');

//     GenerateNcByAppActivityResponseModel generateNcByAppActivityResponseModel =
//         GenerateNcByAppActivityResponseModel.fromJson(response);

//     log('generateNcByAppActivityResponseModel --- response>> $response');

//     return generateNcByAppActivityResponseModel;
//   }

// //////get activity type

//   Future<dynamic> ncgetactivitytypeRepo(int activity_id,
//       {Map<String, dynamic>? map}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.ncGetActivityType,
//       apiType: APIType.aPost,
//       body: {'activity_id': activity_id},
//       header: header1,
//     );

//     log('generateNcByAppActivityTypeResponseModel --- response>> $response');

//     GenerateNcByAppActivityTypeResponseModel
//         generateNcByAppActivityTypeResponseModel =
//         GenerateNcByAppActivityTypeResponseModel.fromJson(response);

//     log('generateNcByAppActivityTypeResponseModel --- response>> $response');

//     return generateNcByAppActivityTypeResponseModel;
//   }

// //////get activity type checklist
//   Future<dynamic> ncgetactivitytypechecklistRepo(int patn_id,
//       {Map<String, dynamic>? map}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.ncGetActivityTypeChecklist,
//       apiType: APIType.aPost,
//       body: {'patn_id': patn_id},
//       header: header1,
//     );

//     log('generateNcByAppActivityTypeChecklistResponseModel --- response>> $response');

//     GenerateNcByAppActivityTypeChecklistResponseModel
//         generateNcByAppActivityTypeChecklistResponseModel =
//         GenerateNcByAppActivityTypeChecklistResponseModel.fromJson(response);

//     log('generateNcByAppActivityTypeChecklistResponseModel --- response>> $response');

//     return generateNcByAppActivityTypeChecklistResponseModel;
//   }

// ///// project responsible user name
//   Future<dynamic> ncgetprojectresponsibleRepo(
//       Map<String, dynamic>? body) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.ncprojectresponsiblelist,
//       apiType: APIType.aPost,
//       body: body,
//       header: header1,
//     );

//     log('generateNcProjectResponsibleTypeResponseModel --- response>> $response');

//     GenerateNcProjectResponsibleTypeResponseModel
//         generateNcProjectResponsibleTypeResponseModel =
//         GenerateNcProjectResponsibleTypeResponseModel.fromJson(response);

//     log('generateNcProjectResponsibleTypeResponseModel --- response>> $response');

//     return generateNcProjectResponsibleTypeResponseModel;
//   }

// /////submit nc
//   // Future<dynamic> ncsubmitbuttonRepo({Map<String, dynamic>? body}) async {
//   //   var response = await APIService().getResponse(
//   //     url: ApiRouts.ncsubmitbutton,
//   //     apiType: APIType.aPost,
//   //     body: body ?? {},
//   //     header: header1,
//   //   );

//   //   log('submitNcDataResponseModel --- raw response>> $response');

//   //   if (response is List<dynamic> && response.isNotEmpty) {
//   //     var firstElement = response[0];
//   //     if (firstElement is Map<String, dynamic>) {
//   //       return SubmitNcDataResponseModel.fromJson(firstElement);
//   //     } else {
//   //       throw Exception("Invalid response format.");
//   //     }
//   //   } else {
//   //     throw Exception("Empty or invalid response.");
//   //   }
//   // }
//   Future<dynamic> ncsubmitbuttonRepo({Map<String, dynamic>? body}) async {
//     try {
//       var response = await APIService().getResponse(
//         url: ApiRouts.ncsubmitbutton,
//         apiType: APIType.aPost,
//         body: body ?? {},
//         header: header1,
//       );

//       log('submitNcDataResponseModel --- raw response>> $response');

//       if (response == null) {
//         throw Exception("Empty response from server.");
//       }

//       // ✅ Handle Map-based JSON
//       if (response is Map<String, dynamic>) {
//         return response;
//       }

//       // ✅ Handle List-based JSON (optional edge case)
//       if (response is List &&
//           response.isNotEmpty &&
//           response.first is Map<String, dynamic>) {
//         return response.first;
//       }

//       // ✅ Handle String-based responses (plain text)
//       if (response is String) {
//         try {
//           return jsonDecode(response);
//         } catch (e) {
//           // If plain text message
//           return {"status": "success", "message": response};
//         }
//       }

//       throw Exception("Invalid response format.");

//       // } catch (e) {
//       //   log("Error in ncsubmitbuttonRepo: $e");
//       //   throw Exception("Form submission failed: $e");
//       // }
//     } catch (e) {
//       log("Error in ncsubmitbuttonRepo: $e");

//       // ✅ Ignore harmless "connection closed" errors if the server still processes successfully
//       if (e.toString().contains("Connection closed while receiving data")) {
//         log("⚠️ Connection closed early, but likely success — ignoring...");
//         return {"status": "success", "message": "NC submitted successfully"};
//       }

//       // ✅ For any other real errors, throw normally
//       throw Exception("Form submission failed: $e");
//     }
//   }

// /////fetch all nc data

//   // Future ncfetchalldataRepo({Map<String, dynamic>? body}) async {
//   //   var response = await APIService().getResponse(
//   //     url: ApiRouts.ncfetchalldata,
//   //     apiType: APIType.aPost,
//   //     body: {},
//   //     header: header1,
//   //   );

//   //   log('FetchAllNcDataResponseModel --- raw response>> $response');

//   //   if (response is List && response.isNotEmpty) {
//   //     var firstElement = response[0];

//   //     if (firstElement is Map<String, dynamic>) {
//   //       if (firstElement.containsKey('status') &&
//   //           firstElement['status'] == 'error') {
//   //         throw Exception('API Error: ${firstElement['message']}');
//   //       }

//   //       FetchAllNcDataResponseModel fetchAllNcDataResponseModel =
//   //           FetchAllNcDataResponseModel.fromJson(firstElement);

//   //       log('fetchAllNcDataResponseModel --- response>> $fetchAllNcDataResponseModel');

//   //       return fetchAllNcDataResponseModel;
//   //     } else {
//   //       throw Exception(
//   //           'Expected a Map but received a List element that is not a Map');
//   //     }
//   //   } else if (response is String) {
//   //     throw Exception('Expected a Map but received a String: $response');
//   //   } else {
//   //     throw Exception('Invalid response format');
//   //   }
//   // }
//   //26/11 11:47pm
//   Future ncfetchalldataRepo({bool forceRefresh = false}) async {
//     var response = await APIService().getResponse(
//       url: forceRefresh
//           ? "${ApiRouts.ncfetchalldata}?nocache=${DateTime.now().millisecondsSinceEpoch}"
//           : ApiRouts.ncfetchalldata,
//       apiType: APIType.aPost,
//       body: {},
//       header: header1,
//     );

//     log('FetchAllNcDataResponseModel --- raw response>> $response');

//     if (response is List && response.isNotEmpty) {
//       var firstElement = response[0];

//       if (firstElement is Map<String, dynamic>) {
//         if (firstElement.containsKey('status') &&
//             firstElement['status'] == 'error') {
//           throw Exception('API Error: ${firstElement['message']}');
//         }

//         FetchAllNcDataResponseModel model =
//             FetchAllNcDataResponseModel.fromJson(firstElement);

//         log('fetchAllNcDataResponseModel --- response>> $model');
//         return model;
//       } else {
//         throw Exception(
//             'Expected a Map but received a List element that is not a Map');
//       }
//     } else {
//       throw Exception('Invalid response format');
//     }
//   }
// //===================

//   ///nc close state

//   Future<dynamic> closencstateRepo(int nc_id,
//       {Map<String, dynamic>? map}) async {
//     if (map == null || map.isEmpty) {
//       log('Missing map parameter in API call.');
//       return null;
//     }

//     var response = await APIService().getResponse(
//       url: ApiRouts.ncclosestate,
//       apiType: APIType.aPost,
//       body: map,
//       header: header1,
//     );
//     //  print("API raw data: $response");

//     log('generateNcCloseStateResponseModel --- response>> $response');

//     if (response is List && response.isNotEmpty) {
//       var status = response[0]['status'];
//       var message = response[0]['message'];

//       if (status == 'error') {
//         log('Error: $message');
//         return null;
//       }

//       GenerateNcCloseStateResponseModel generateNcCloseStateResponseModel =
//           GenerateNcCloseStateResponseModel.fromJson(response[0]);

//       log('generateNcCloseStateResponseModel --- response>> $generateNcCloseStateResponseModel');
//       return generateNcCloseStateResponseModel;
//     } else {
//       log('Unexpected response format: $response');
//       return null;
//     }
//   }

// /////////////////Approver Reject NC////
//   Future<dynamic> approverRejectNcRepo({Map<String, dynamic>? map}) async {
//     if (map == null || map.isEmpty) {
//       log('Missing map parameter in Approver Reject API call.');
//       return null;
//     }

//     var response = await APIService().getResponse(
//       url: ApiRouts.approverRejectNc,
//       apiType: APIType.aPost,
//       body: map,
//       header: header1,
//     );

//     log('approverRejectNcRepo --- raw response >> $response');

//     if (response is Map<String, dynamic>) {
//       if (response['status'] == 'error') {
//         log('Error: ${response['message']}');
//         return null;
//       }

//       // Convert to model
//       ApproverRejectNcResponseModel model =
//           ApproverRejectNcResponseModel.fromJson(response);

//       log("approverRejectNcRepo --- parsed model >> $model");
//       return model;
//     }

//     // Unexpected format
//     log("Unexpected response format: $response");
//     return null;
//   }

//   ///////////////Approver close NC////
//   //// APPROVER CLOSE NC ////
//   Future<dynamic> approverCloseNcRepo({Map<String, dynamic>? map}) async {
//     if (map == null || map.isEmpty) {
//       log('Missing map parameter in Approver Close API call.');
//       return null;
//     }

//     var response = await APIService().getResponse(
//       url: ApiRouts.approverCloseNc, // <<< CREATE THIS ROUTE
//       apiType: APIType.aPost,
//       body: map,
//       header: header1,
//     );

//     log("approverCloseNcRepo --- raw response >> $response");

//     if (response is Map<String, dynamic>) {
//       if (response['status'] == 'error') {
//         log("Error: ${response['message']}");
//         return null;
//       }

//       ApproverCloseNcResponseModel model =
//           ApproverCloseNcResponseModel.fromJson(response);

//       return model;
//     }

//     log("Unexpected response format: $response");
//     return null;
//   }

//   ////////// Nc routing through notification /////////////////
//   Future<dynamic> getNotificationRoutingForNc(
//       {Map<String, dynamic>? map}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.ncRoutingThroughNotification,
//       apiType: APIType.aPost,
//       body: map ?? {},
//       header: header1,
//     );

//     print("RAW TYPE: ${response.runtimeType}");
//     print("RAW DATA: $response");

//     /// FIX: If API response is a LIST → extract first element
//     if (response is List) {
//       if (response.isNotEmpty && response.first is Map) {
//         response = response.first; // unwrap actual json
//       } else {
//         throw Exception("Invalid NC Routing response format");
//       }
//     }

//     NcRoutingThroughNotificationResponseModel model =
//         NcRoutingThroughNotificationResponseModel.fromJson(response);

//     print("Parsed Model: ${model.toJson()}");
//     return model;
//   }
// }
