import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modals/WeeklyWorkoutPlan.dart';

class HiveService {
  static const _workoutBoxName = 'WorkoutPlan2';

  static Future<Box<WorkoutPlan2>> _openWorkoutBox() async {
    if (!Hive.isBoxOpen(_workoutBoxName)) {
      return await Hive.openBox<WorkoutPlan2>(_workoutBoxName);
    }
    return Hive.box<WorkoutPlan2>(_workoutBoxName);
  }

  static Future<WorkoutPlan2?> getWorkoutPlan2(String key) async {
    final box = await _openWorkoutBox();
    return box.get(key);
  }

  static Future<void> saveWorkoutPlan2(String key, WorkoutPlan2 plan) async {
    final prefs = await SharedPreferences.getInstance();
   await prefs.setInt('start_day', DateTime.now().day);
    await prefs.setInt('start_month', DateTime.now().month);

    final box = await _openWorkoutBox();
    await box.put(key, plan);
  }

  static Future<void> deleteWorkoutPlan2(String key) async {
    final box = await _openWorkoutBox();
    await box.delete(key);
  }

  static Future<void> clearWorkoutPlan2s() async {
    final box = await _openWorkoutBox();
    await box.clear();
  }

  static Future<bool> isWorkoutPlan2Stored(String key) async {
    final box = await _openWorkoutBox();
    return box.containsKey(key);
  }
}
