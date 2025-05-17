import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/services/loaclPlanStoreService.dart';
import '../../../modals/TaskEntity.dart';
import '../../../modals/workoutPlan.dart';
import '../../../utils/utils.dart';
import '../../goal/repo/taskRepo.dart';

// final workoutPlanProvider = FutureProvider<WorkoutPlan?>((ref) async {
//   final plan = await HiveService.getWorkoutPlan2('myPlan');
//   return plan;
// });
//
// final todaysWorkoutProvider = FutureProvider<List<Map<String, String>>>((ref) async {
//   final planAsync = await ref.watch(workoutPlanProvider.future);
//
//   if (planAsync == null) return [];
//
//   final day = getTodayDayName();
//   final month = await _getMonth();
//
//   final workoutType = planAsync.weeklySchedule[day];
//
//   if (workoutType == null) return [];
//
//   final workouts = {
//     'month_1': planAsync.workouts.month1,
//     'month_2': planAsync.workouts.month2,
//     'month_3': planAsync.workouts.month3,
//   };
//
//   return workouts[month]?[workoutType] ?? [];
// });

final todayTaskProvider = FutureProvider<List<TaskEntity>>((ref) async {
  print("ferching today tasks");
  final tasks = await TaskService.getAllTasks();
  final today = DateTime.now();
  final todayWeekday = today.weekday % 7; // Flutter weekday: 1-7, Sunday is 7

  final todayTasks = tasks.where((task) {
    return task.repeatOn == todayWeekday &&
        task.startDate.isBefore(today.add(Duration(days: 1))) &&
        task.endDate.isAfter(today.subtract(Duration(days: 1)));
  }).toList();
  // ..sort((a, b) => a.isCompleted ? 1 : -1);

  // First: separate by type
  final warmUps = todayTasks.where((t) => t.title.toUpperCase() == 'WARM-UP').toList();
  final exercises = todayTasks.where((t) => t.title.toUpperCase() == 'EXERCISE').toList();
  final coolDowns = todayTasks.where((t) => t.title.toUpperCase() == 'COOL-DOWN').toList();

  // Combine in order
  final orderedTasks = [...warmUps, ...exercises, ...coolDowns];

  // Optional: sort by completion status inside each group
  // orderedTasks.sort((a, b) => a.isCompleted ? 1 : -1);

  return orderedTasks;
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
  if (diff < 90) return 'mont_3';
  return null;
}
