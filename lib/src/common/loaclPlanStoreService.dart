import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modals/workoutPlan.dart';

class HiveService {
  static const _workoutBoxName = 'workoutPlans';

  static Future<Box<WorkoutPlan>> _openWorkoutBox() async {
    if (!Hive.isBoxOpen(_workoutBoxName)) {
      return await Hive.openBox<WorkoutPlan>(_workoutBoxName);
    }
    return Hive.box<WorkoutPlan>(_workoutBoxName);
  }

  static Future<WorkoutPlan?> getWorkoutPlan(String key) async {
    final box = await _openWorkoutBox();
    return box.get(key);
  }

  static Future<void> saveWorkoutPlan(String key, WorkoutPlan plan) async {
    final prefs = await SharedPreferences.getInstance();
   await prefs.setInt('start_day', DateTime.now().day);
    await prefs.setInt('start_month', DateTime.now().month);

    final box = await _openWorkoutBox();
    await box.put(key, plan);
  }

  static Future<void> deleteWorkoutPlan(String key) async {
    final box = await _openWorkoutBox();
    await box.delete(key);
  }

  static Future<void> clearWorkoutPlans() async {
    final box = await _openWorkoutBox();
    await box.clear();
  }

  static Future<bool> isWorkoutPlanStored(String key) async {
    final box = await _openWorkoutBox();
    return box.containsKey(key);
  }
}
