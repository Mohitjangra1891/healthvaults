import 'package:hive/hive.dart';

part 'workoutPlan.g.dart'; // This is required for code generation

@HiveType(typeId: 0)
class WorkoutPlan extends HiveObject {
  @HiveField(0)
  final String planName;

  @HiveField(1)
  final String achievement;

  @HiveField(2)
  final Map<String, String> weeklySchedule;

  @HiveField(3)
  final WorkoutMonth workouts;

  WorkoutPlan({
    required this.planName,
    required this.achievement,
    required this.weeklySchedule,
    required this.workouts,
  });



  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      planName: json['plan_name'] as String,
      achievement: json['achievement'] as String,
      weeklySchedule: (json['weekly_schedule'] as Map<String, dynamic>).cast<String, String>(),
      workouts: WorkoutMonth.fromJson(json['workouts'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_name': planName,
      'achievement': achievement,
      'weekly_schedule': weeklySchedule,
      'workouts': workouts.toJson(),
    };
  }
}


@HiveType(typeId: 1)
class WorkoutMonth extends HiveObject {
  @HiveField(0)
  final Map<String, List<Map<String, String>>> month1;

  @HiveField(1)
  final Map<String, List<Map<String, String>>> month2;

  @HiveField(2)
  final Map<String, List<Map<String, String>>> month3;

  WorkoutMonth({
    required this.month1,
    required this.month2,
    required this.month3,
  });


  factory WorkoutMonth.fromJson(Map<String, dynamic> json) {
    return WorkoutMonth(
      month1: (json['month_1'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => (e as Map<String, dynamic>).cast<String, String>()).toList(),
        ),
      ),
      month2: (json['month_2'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => (e as Map<String, dynamic>).cast<String, String>()).toList(),
        ),
      ),
      month3: (json['month_3'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => (e as Map<String, dynamic>).cast<String, String>()).toList(),
        ),
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'month_1': month1.map((key, value) => MapEntry(key, value)),
      'month_2': month2.map((key, value) => MapEntry(key, value)),
      'month_3': month3.map((key, value) => MapEntry(key, value)),
    };
  }
}
