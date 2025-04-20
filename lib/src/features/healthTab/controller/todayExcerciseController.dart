import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/services/loaclPlanStoreService.dart';
import '../../../modals/workoutPlan.dart';
import '../../../utils/utils.dart';

final workoutPlanProvider = FutureProvider<WorkoutPlan?>((ref) async {
  final plan = await HiveService.getWorkoutPlan('myPlan');
  return plan;
});

final todaysWorkoutProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  final planAsync = await ref.watch(workoutPlanProvider.future);

  if (planAsync == null) return [];

  final day = getTodayDayName();
  final month = await _getMonth();

  final workoutType = planAsync.weeklySchedule[day];

  if (workoutType == null) return [];

  final workouts = {
    'month_1': planAsync.workouts.month1,
    'month_2': planAsync.workouts.month2,
    'month_3': planAsync.workouts.month3,
  };

  return workouts[month]?[workoutType] ?? [];
});

Future<String?> _getMonth() async {
   final startdate;

  final prefs = await SharedPreferences.getInstance();
  final day = prefs.getInt('start_day');
  final month = prefs.getInt('start_month');
    startdate = DateTime(DateTime.now().year, month!, day!);


  final diff = DateTime.now().difference(startdate).inDays;

  if (diff < 0) return null;
  if (diff < 30) return 'month_1';
  if (diff < 60) return 'month_2';
  if (diff < 90) return 'mont3';
  return null;
}

