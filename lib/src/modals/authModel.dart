class VerifyOtpResponse {
  final int status;
  final String message;
  final VerifyOtpData data;

  VerifyOtpResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['status'],
      message: json['message'],
      data: VerifyOtpData.fromJson(json['data']),
    );
  }
}

class VerifyOtpData {
  final bool? existingUser;
  final String message;
  final Profile profile;
  final User user;

  VerifyOtpData({
    required this.existingUser,
    required this.message,
    required this.profile,
    required this.user,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      existingUser: json['existingUser'],
      message: json['message'],
      profile: Profile.fromJson(json['profile']),
      user: User.fromJson(json['user']),
    );
  }
}

class Profile {
  final String? id;
  final String? profileId;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? dob;
  final String? ownerId;
  final bool? userprofile;
  final String? dp;
  final String? createdAt;
  final String? updatedAt;

  Profile({
    this.id,
    this.profileId,
    this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.ownerId,
    this.userprofile,
    this.dp,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      profileId: json['profileId'],
      // Not in your JSON but kept optional
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      dob: json['dob'],
      ownerId: json['owner_id'],
      userprofile: json['userprofile'],
      dp: json['dp'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "profileId": profileId,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "dob": dob,
        "owner_id": ownerId,
        "userprofile": userprofile,
        "dp": dp,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class User {
  final String? id;
  final String? userId;
  final String? profileId;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? gender;
  final String? dob;
  final String? token;
  final String? refreshToken;
  final String? dp;
  final List<String>? owned;
  final List<String>? shared;
  final String? deviceToken;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.userId,
    this.profileId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.gender,
    this.dob,
    this.token,
    this.refreshToken,
    this.dp,
    this.owned,
    this.shared,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userId: json['user_id'],
      profileId: json['profile_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phonenumber'],
      gender: json['gender'],
      dob: json['dob'],
      token: json['token'],
      refreshToken: json['refresh_token'],
      dp: json['dp'],
      owned: json['owned'] != null ? List<String>.from(json['owned']) : null,
      shared: json['shared'] != null ? List<String>.from(json['shared']) : null,
      deviceToken: json['devicetoken'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

// class Profile {
//   final String id;
//   final String profileId;
//   final String firstName;
//   final String lastName;
//   final String gender;
//   final String dob;
//   final String ownerId;
//   final bool userprofile;
//   final String dp;
//   final String createdAt;
//   final String updatedAt;
//
//   Profile({
//     required this.id,
//     required this.profileId,
//     required this.firstName,
//     required this.lastName,
//     required this.gender,
//     required this.dob,
//     required this.ownerId,
//     required this.userprofile,
//     required this.dp,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//       id: json['id'],
//       profileId: json['profileId'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       gender: json['gender'],
//       dob: json['dob'],
//       ownerId: json['owner_id'],
//       userprofile: json['userprofile'],
//       dp: json['dp'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }

// class User {
//   final String id;
//   final String userId;
//   final String profileId;
//   final String firstName;
//   final String lastName;
//   final String phoneNumber;
//   final String gender;
//   final String dob;
//   final String token;
//   final String refreshToken;
//   final String dp;
//   final List<String> owned;
//   final List<String> shared;
//   final String deviceToken;
//   final String createdAt;
//   final String updatedAt;
//
//   User({
//     required this.id,
//     required this.userId,
//     required this.profileId,
//     required this.firstName,
//     required this.lastName,
//     required this.phoneNumber,
//     required this.gender,
//     required this.dob,
//     required this.token,
//     required this.refreshToken,
//     required this.dp,
//     required this.owned,
//     required this.shared,
//     required this.deviceToken,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       userId: json['user_id'],
//       profileId: json['profile_id'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       phoneNumber: json['phonenumber'],
//       gender: json['gender'],
//       dob: json['dob'],
//       token: json['token'],
//       refreshToken: json['refresh_token'],
//       dp: json['dp'],
//       owned: List<String>.from(json['owned']),
//       shared: List<String>.from(json['shared']),
//       deviceToken: json['devicetoken'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }
