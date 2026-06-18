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
      uid: json['uid'] as int?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      profileImage: json['profile_image'] as String?,
      userType: json['user_type'] as String?,
      session: json['session'] != null
          ? SessionData.fromJson(json['session'] as Map<String, dynamic>)
          : null,
      status: json['status'] as String?,
      message: json['message'] as String?,
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
      sid: json['sid'] as String?,
      expiresAt: json['expires_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sid'] = sid;
    data['expires_at'] = expiresAt;
    return data;
  }
}
