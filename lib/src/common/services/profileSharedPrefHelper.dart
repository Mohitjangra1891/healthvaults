import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../modals/authModel.dart';

class ProfileStorageHelper {
  static const _key = 'cached_profiles';

  static Future<void> saveProfiles(List<Profile> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(profiles.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<List<Profile>> loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List list = jsonDecode(jsonString);
    return list.map((e) => Profile.fromJson(e)).toList();
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

