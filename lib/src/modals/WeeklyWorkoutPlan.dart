import 'package:hive/hive.dart';

part 'WeeklyWorkoutPlan.g.dart';

@HiveType(typeId: 4)
class WorkoutPlan2 extends HiveObject {
  @HiveField(0)
  final String planName;

  @HiveField(1)
  final String achievement;

  @HiveField(2)
  final String remark1;

  @HiveField(3)
  final String remark2;

  @HiveField(4)
  final Map<String, WorkoutDay> workouts;

  @HiveField(5)
  final List<String> reflectionQuestions;

  WorkoutPlan2({
    required this.planName,
    required this.achievement,
    required this.remark1,
    required this.remark2,
    required this.workouts,
    required this.reflectionQuestions,
  });

  factory WorkoutPlan2.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan2(
      planName: json['plan_name'] as String,
      achievement: json['achievement'] as String,
      remark1: json['remark_1'] as String,
      remark2: json['remark_2'] as String,
      workouts: (json['workouts'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          WorkoutDay.fromJson(value as Map<String, dynamic>),
        ),
      ),
      reflectionQuestions: List<String>.from(json['reflection_questions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_name': planName,
      'achievement': achievement,
      'remark_1': remark1,
      'remark_2': remark2,
      'workouts': workouts.map((key, value) => MapEntry(key, value.toJson())),
      'reflection_questions': reflectionQuestions,
    };
  }
}

@HiveType(typeId: 5)
class WorkoutDay extends HiveObject {
  @HiveField(0)
  final String theme;

  @HiveField(1)
  final List<RoutineItem> routine;

  @HiveField(2)
  final String coachTip;

  @HiveField(3)
  final String commonMistake;

  @HiveField(4)
  final String alternative;

  WorkoutDay({
    required this.theme,
    required this.routine,
    required this.coachTip,
    required this.commonMistake,
    required this.alternative,
  });

  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      theme: json['theme'] as String,
      routine: (json['routine'] as List<dynamic>)
          .map((e) => RoutineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      coachTip: json['coach_tip'] as String,
      commonMistake: json['common_mistake'] as String,
      alternative: json['alternative'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'routine': routine.map((e) => e.toJson()).toList(),
      'coach_tip': coachTip,
      'common_mistake': commonMistake,
      'alternative': alternative,
    };
  }
}

@HiveType(typeId: 6)
class RoutineItem extends HiveObject {
  @HiveField(0)
  final String? warmUp;

  @HiveField(1)
  final String? exercise;

  @HiveField(2)
  final String? coolDown;

  @HiveField(3)
  final String instruction;

  @HiveField(4)
  final String? reps;

  @HiveField(5)
  final String? duration;

  RoutineItem({
    this.warmUp,
    this.exercise,
    this.coolDown,
    required this.instruction,
    this.reps,
    this.duration,
  });

  factory RoutineItem.fromJson(Map<String, dynamic> json) {
    return RoutineItem(
      warmUp: json['warm_up'] as String?,
      exercise: json['exercise'] as String?,
      coolDown: json['cool_down'] as String?,
      instruction: json['instruction'] as String,
      reps: json['reps'] as String?,
      duration: json['duration'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (warmUp != null) 'warm_up': warmUp,
      if (exercise != null) 'exercise': exercise,
      if (coolDown != null) 'cool_down': coolDown,
      'instruction': instruction,
      if (reps != null) 'reps': reps,
      if (duration != null) 'duration': duration,
    };
  }
}

