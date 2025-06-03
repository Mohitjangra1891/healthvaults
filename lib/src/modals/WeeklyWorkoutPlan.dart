import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'WeeklyWorkoutPlan.g.dart';

/// UTILITY EXTENSION on `WorkoutPlan2` for computed properties:
extension WorkoutPlanUtils on WorkoutPlan2 {
  /// Has 7 days passed?
  bool get isWeekOneCompleted {
    final daysElapsed = DateTime.now().difference(startDate!).inDays;
    return daysElapsed >= 7;
  }

  /// What is today’s day key? (e.g. "Monday")
  String get _todayKey => DateFormat('EEEE').format(DateTime.now());

  WorkoutDay? get todayWorkout => workouts[_todayKey];

  /// Total exercises in today’s routine
  int get todayTotalExercises => todayWorkout?.routine.length ?? 0;

  /// Completed items count
  int get todayCompletedExercises => todayWorkout?.routine.where((e) => e.isCompleted).length ?? 0;
}

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
  @HiveField(6)
  final DateTime startDate;

  WorkoutPlan2({
    required this.planName,
    required this.achievement,
    required this.remark1,
    required this.remark2,
    required this.workouts,
    required this.reflectionQuestions,
    required this.startDate,
  });

  /// ✅ Add this copyWith method
  WorkoutPlan2 copyWith({
    String? planName,
    String? achievement,
    String? remark1,
    String? remark2,
    Map<String, WorkoutDay>? workouts,
    List<String>? reflectionQuestions,
    DateTime? startDate,
  }) {
    return WorkoutPlan2(
      planName: planName ?? this.planName,
      achievement: achievement ?? this.achievement,
      remark1: remark1 ?? this.remark1,
      remark2: remark2 ?? this.remark2,
      workouts: workouts ?? this.workouts,
      reflectionQuestions: reflectionQuestions ?? this.reflectionQuestions,
      startDate: startDate ?? this.startDate,
    );
  }

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
      startDate: DateTime.parse(json['start_date']),
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
      'start_date': startDate?.toIso8601String() ?? " ",
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
      routine: (json['routine'] as List<dynamic>).map((e) => RoutineItem.fromJson(e as Map<String, dynamic>)).toList(),
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
  String type; // 'warm_up', 'exercise', or 'cool_down'

  @HiveField(1)
  String name; // e.g., 'Barbell Squats'

  @HiveField(2)
  String instruction;

  @HiveField(3)
  String? duration;

  @HiveField(4)
  String? reps;
  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  String? userNote;
  @HiveField(7)
  int completedIN;

  RoutineItem({
    required this.type,
    required this.name,
    required this.instruction,
    this.duration,
    this.reps,
    this.isCompleted = false,
    this.userNote,
    this.completedIN = 0,
  });

  factory RoutineItem.fromJson(Map<String, dynamic> json) {
    // Determine type and name
    String type = json.containsKey('warm_up')
        ? 'warm_up'
        : json.containsKey('exercise')
            ? 'exercise'
            : 'cool_down';

    String name = json[type];

    return RoutineItem(
      type: type,
      name: name,
      instruction: json['instruction'] ?? '',
      duration: json['duration'],
      reps: json['reps'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'instruction': instruction,
      if (duration != null) 'duration': duration,
      if (reps != null) 'reps': reps,
      // Optional fields not part of original JSON
      'isCompleted': isCompleted,
      'completedIN': completedIN,
      'userNote': userNote,
    };
  }
}
