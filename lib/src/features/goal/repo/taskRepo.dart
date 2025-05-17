import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../../../modals/TaskEntity.dart';
import '../../../modals/workoutPlan.dart';
import '../../../modals/WeeklyWorkoutPlan.dart';

class TaskService {
  static const _taskBoxName = 'tasks';

  static Future<Box<TaskEntity>> _openTaskBox() async {
    if (!Hive.isBoxOpen(_taskBoxName)) {
      return await Hive.openBox<TaskEntity>(_taskBoxName);
    }
    return Hive.box<TaskEntity>(_taskBoxName);
  }

  static Future<void> addTask(TaskEntity task) async {
    final box = await _openTaskBox();
    await box.put(task.id, task);
    print("task added");
  }

  static Future<List<TaskEntity>> getAllTasks() async {
    final box = await _openTaskBox();
    return box.values.toList();
  }

  static Future<void> updateTask(TaskEntity task) async {
    final box = await _openTaskBox();
    await box.put(task.id, task);
  }

  static Future<void> clearTasks() async {
    final box = await _openTaskBox();
    await box.clear();
  }
}

Future<void> setGoal(List<int> goals, WorkoutPlan workoutPlan, String userId) async {
  int goalValue = 0;
  for (var g in goals) {
    goalValue += g * g;
  }

  await TaskService.clearTasks(); // clear old tasks

  final weekSchedule = workoutPlan.weeklySchedule;
  final months = [
    workoutPlan.workouts.month1,
    workoutPlan.workouts.month2,
    workoutPlan.workouts.month3,
  ];

  for (int i = 0; i < months.length; i++) {
    final month = months[i];
    for (var entry in weekSchedule.entries) {
      final dayName = entry.key;
      final workoutType = entry.value;
      final tasks = month[workoutType];

      if (tasks == null) continue;

      for (var task in tasks) {
        final keys = task.keys.toList();
        final key = keys.isNotEmpty ? keys.first : 'exercise';
        final title = key.replaceAll('_', ' ').toUpperCase();

        final value = task[key]?.replaceAll(RegExp(r'\s*\(.*?\)'), '');

        // final values = task.values.toList();

        final newTask = TaskEntity(
          id: UniqueKey().toString(),
          userId: userId,
          goal: goalValue,
          period: 28,
          title: title,
          value: value!,
          description: task['reps'] ?? task['duration'] ?? "",
          time: "09:00",
          startDate: DateTime.now().add(Duration(days: i * 28)),
          endDate: DateTime.now().add(Duration(days: (i + 1) * 28)),
          repeatOn: getWeekInt(dayName),
          isActive: false,
          isCompleted: false,
        );
        log(newTask.value+newTask.description);
        // log(newTask.value + newTask.description);
        await TaskService.addTask(newTask);
      }
    }
  }
}
Future<void> setWeekGoal(List<int> goals, WorkoutPlan2 workoutPlan, String userId) async {
  int goalValue = 0;
  for (var g in goals) {
    goalValue += g * g;
  }

  await TaskService.clearTasks(); // clear old tasks

  // Iterate days
  for (var entry in workoutPlan.workouts.entries) {
    final dayKey = entry.key;
    final workoutDay = entry.value;
    final repeatOn = _weekdayStringToInt(dayKey);

    for (var step in workoutDay.routine) {
      final Map<String, String?> fields = {
        if (step.warmUp != null) 'Warm-up': step.warmUp,
        if (step.exercise != null) 'Exercise': step.exercise,
        if (step.coolDown != null) 'Cool-down': step.coolDown,
      };

      final type = fields.keys.first;
      final title = type.toUpperCase();
      final value = fields.values.first ?? '';

      final description = step.reps ?? step.duration ?? '';
      final now = DateTime.now();

      final task = TaskEntity(
        id: UniqueKey().toString(),
        userId: userId,
        goal: goalValue,
        period: 7,
        title: title,
        value: value,
        description: description,
        time: '09:00',
        startDate: now,
        endDate: now.add(Duration(days: 7)),
        repeatOn: repeatOn,
        isActive: false,
        isCompleted: false,
      );
      log(task.value+task.description);

      await TaskService.addTask(task);
    }
  }
}
/// Converts weekday string (e.g. "Monday") to Dart DateTime weekday int
int _weekdayStringToInt(String day) {
  switch (day.toLowerCase()) {
    case 'monday': return DateTime.monday;
    case 'tuesday': return DateTime.tuesday;
    case 'wednesday': return DateTime.wednesday;
    case 'thursday': return DateTime.thursday;
    case 'friday': return DateTime.friday;
    case 'saturday': return DateTime.saturday;
    case 'sunday': return DateTime.sunday;
    default: return 0;
  }
}

int getWeekInt(String dayName) {
  switch (dayName.toLowerCase()) {
    case 'sunday':
      return 0;
    case 'monday':
      return 1;
    case 'tuesday':
      return 2;
    case 'wednesday':
      return 3;
    case 'thursday':
      return 4;
    case 'friday':
      return 5;
    case 'saturday':
      return 6;
    default:
      return 0;
  }
}
