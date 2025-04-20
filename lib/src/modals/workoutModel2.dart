// class WorkoutPlan {
//   final String planName;
//   final String achievement;
//   final Map<String, String> weeklySchedule;
//   final WorkoutMonth workouts;
//
//   WorkoutPlan({
//     required this.planName,
//     required this.achievement,
//     required this.weeklySchedule,
//     required this.workouts,
//   });
//
//   factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
//     return WorkoutPlan(
//       planName: json['plan_name'] as String,
//       achievement: json['achievement'] as String,
//       weeklySchedule: (json['weekly_schedule'] as Map<String, dynamic>).cast<String, String>(),
//       workouts: WorkoutMonth.fromJson(json['workouts'] as Map<String, dynamic>),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'plan_name': planName,
//       'achievement': achievement,
//       'weekly_schedule': weeklySchedule,
//       'workouts': workouts.toJson(),
//     };
//   }
// }
//
// class WorkoutMonth {
//   final Map<String, List<Map<String, String>>> month1;
//   final Map<String, List<Map<String, String>>> month2;
//   final Map<String, List<Map<String, String>>> month3;
//
//   WorkoutMonth({
//     required this.month1,
//     required this.month2,
//     required this.month3,
//   });
//
//   factory WorkoutMonth.fromJson(Map<String, dynamic> json) {
//     return WorkoutMonth(
//       month1: (json['month_1'] as Map<String, dynamic>).map(
//             (key, value) => MapEntry(
//           key,
//           (value as List<dynamic>).map((e) => (e as Map<String, dynamic>).cast<String, String>()).toList(),
//         ),
//       ),
//       month2: (json['month_2'] as Map<String, dynamic>).map(
//             (key, value) => MapEntry(
//           key,
//           (value as List<dynamic>).map((e) => (e as Map<String, dynamic>).cast<String, String>()).toList(),
//         ),
//       ),
//       month3: (json['month_3'] as Map<String, dynamic>).map(
//             (key, value) => MapEntry(
//           key,
//           (value as List<dynamic>).map((e) => (e as Map<String, dynamic>).cast<String, String>()).toList(),
//         ),
//       ),
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'month_1': month1.map((key, value) => MapEntry(key, value)),
//       'month_2': month2.map((key, value) => MapEntry(key, value)),
//       'month_3': month3.map((key, value) => MapEntry(key, value)),
//     };
//   }
//
//
// }
