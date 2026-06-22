import '../Utils/api_parser.dart';

class LoginResponseModel {
  final int? uid;
  final String? name;
  final String? username;
  final String? profileImage;
  final String? userType;
  final SessionData? session;
  final String? status;
  final String? message;

  LoginResponseModel({
    this.uid,
    this.name,
    this.username,
    this.profileImage,
    this.userType,
    this.session,
    this.status,
    this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      uid: ApiParser.parseInt(json['uid']),
      name: ApiParser.parseString(json['name']),
      username: ApiParser.parseString(json['username']),
      profileImage: ApiParser.parseString(json['profile_image']),
      userType: ApiParser.parseString(json['user_type']),
      session: json['session'] != null
          ? SessionData.fromJson(json['session'] as Map<String, dynamic>)
          : null,
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['username'] = username;
    data['profile_image'] = profileImage;
    data['user_type'] = userType;
    if (session != null) {
      data['session'] = session!.toJson();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class SessionData {
  final String? sid;
  final String? expiresAt;

  SessionData({this.sid, this.expiresAt});

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      sid: ApiParser.parseString(json['sid']),
      expiresAt: ApiParser.parseString(json['expires_at']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sid'] = sid;
    data['expires_at'] = expiresAt;
    return data;
  }
}
