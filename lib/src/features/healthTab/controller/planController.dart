// lib/providers/workout_plan_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../../modals/WeeklyWorkoutPlan.dart';

/// PROVIDER: Exposes `WorkoutPlan2?` and allows updates.
final workoutPlanProvider =
StateNotifierProvider<WorkoutPlanNotifier, WorkoutPlan2?>((ref) {
  final box = Hive.box<WorkoutPlan2>('workoutPlanBox');
  return WorkoutPlanNotifier(box);
});

class WorkoutPlanNotifier extends StateNotifier<WorkoutPlan2?> {
  final Box<WorkoutPlan2> box;
  static const _boxKey = 'plan';

  WorkoutPlanNotifier(this.box) : super(box.get(_boxKey)) {
    // Whenever Hive box changes under key 'plan', update state.
    box.watch(key: _boxKey).listen((event) {
      state = event.value as WorkoutPlan2?;
    });
  }

  /// Save a brand‑new plan → writes to Hive + updates state
  Future<void> savePlan(WorkoutPlan2 plan) async {
    await box.put(_boxKey, plan);
    state = plan;
  }

  /// Delete the existing plan (if you ever need to reset)
  Future<void> deletePlan() async {
    await box.delete(_boxKey);
    state = null;
  }

  /// Mark one RoutineItem as completed/incomplete
  /// dayKey: e.g. 'Monday', index: position in that WorkoutDay.routine
  void markExerciseComplete({
    required String dayKey,
    required int index,
    required bool isCompleted,
    required int completedInSeconds,
  }) {
    final current = state;
    if (current == null) return;

    final workoutDay = current.workouts[dayKey];
    if (workoutDay == null) return;

    // Make a copy of the routine list
    final updatedRoutine = [...workoutDay.routine];
    final oldItem = updatedRoutine[index];

    final newItem = RoutineItem(
      type: oldItem.type,
      name: oldItem.name,
      instruction: oldItem.instruction,
      duration: oldItem.duration,
      reps: oldItem.reps,
      isCompleted: isCompleted,
      userNote: oldItem.userNote,
      completedIN: completedInSeconds,
    );

    updatedRoutine[index] = newItem;

    // Build a new WorkoutDay
    final newWorkoutDay = WorkoutDay(
      theme: workoutDay.theme,
      routine: updatedRoutine,
      coachTip: workoutDay.coachTip,
      commonMistake: workoutDay.commonMistake,
      alternative: workoutDay.alternative,
    );

    // Rebuild the workouts map
    final newWorkouts = {
      ...current.workouts,
      dayKey: newWorkoutDay,
    };

    // Create a new WorkoutPlan2 (keeping all other fields)
    final newPlan = WorkoutPlan2(
      planName: current.planName,
      achievement: current.achievement,
      remark1: current.remark1,
      remark2: current.remark2,
      reflectionQuestions: current.reflectionQuestions,
      workouts: newWorkouts,
      startDate: current.startDate,
    );

    savePlan(newPlan); // persist & update state
  }
}
