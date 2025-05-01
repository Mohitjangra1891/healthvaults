import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  static const token = 'token';
  static const refreshToken = 'refresh_token';
  static const userId = 'user_id';
  static const profileId = 'profile_id';
  static const phoneNumber = 'phone_number';
  static const firstName = 'first_name';
  static const lastName = 'last_name';
  static const gender = 'gender';
  static const dob = 'dob';
  static const dp = 'dp';
  static const isExistingUser = 'is_existing_user';
  static const isLoggedIn = 'is_logged_in';
}

class SharedPrefHelper {
  static Future<void> saveLoginDetails({
    required String token,
    required String refreshToken,
    required String userId,
    required String profileId,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String gender,
    required String dob,
    required String dp,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(SharedPrefKeys.token, token);
    await prefs.setString(SharedPrefKeys.refreshToken, refreshToken);
    await prefs.setString(SharedPrefKeys.userId, userId);
    await prefs.setString(SharedPrefKeys.profileId, profileId);
    await prefs.setString(SharedPrefKeys.phoneNumber, phoneNumber);
    await prefs.setString(SharedPrefKeys.firstName, firstName);
    await prefs.setString(SharedPrefKeys.lastName, lastName);
    await prefs.setString(SharedPrefKeys.gender, gender);
    await prefs.setString(SharedPrefKeys.dob, dob);
    await prefs.setString(SharedPrefKeys.dp, dp);
    // await prefs.setBool(SharedPrefKeys.isLoggedIn, true);
  }

  static Future<void> saveIsExistingUser(bool isExistingUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefKeys.isExistingUser, isExistingUser);
  }

  static Future<void> saveDP(String dp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.dp, dp);
  }

  static Future<String?> getDP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKeys.dp);
  }
  static Future<String?> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKeys.userId);
  }

  static Future<void> saveUserLOggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefKeys.isLoggedIn, value);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKeys.token);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString(SharedPrefKeys.firstName ?? '');
    final lastName = prefs.getString(SharedPrefKeys.lastName ?? '');
    return '$firstName $lastName'.trim();
  }

  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKeys.phoneNumber);
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefKeys.isLoggedIn) ?? false;
  }

  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKeys.gender);
  }

  static Future<String?> getDob() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKeys.dob);
  }

  static Future<bool> getIsExistingUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefKeys.isExistingUser) ?? false;
  }

// You can add more getters if needed like getUserId(), getProfileId() etc.
}
