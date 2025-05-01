import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../../../modals/TaskEntity.dart';
import '../../../modals/workoutPlan.dart';

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
        // log(newTask.value + newTask.description);
        await TaskService.addTask(newTask);
      }
    }
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
