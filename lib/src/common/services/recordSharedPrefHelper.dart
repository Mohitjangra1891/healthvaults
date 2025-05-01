
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../modals/authModel.dart';
import '../../modals/record.dart';

class recordStorageHelper {
  static const _key = 'cached_records';

  static Future<void> saverecords(List<MedicalRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(records.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<List<MedicalRecord>> loadrecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List list = jsonDecode(jsonString);
    return list.map((e) => MedicalRecord.fromJson(e)).toList();
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

