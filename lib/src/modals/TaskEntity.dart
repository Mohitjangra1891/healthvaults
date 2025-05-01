//
// class TaskEntity {
//   final String id;
//   final String userId;
//   final int goal;
//   final int period;
//   final String title;
//   final String value;
//   final String description;
//   final String time;
//   final DateTime startDate;
//   final DateTime endDate;
//   final int repeatOn;
//   final bool isActive;
//   final bool isCompleted;
//
//   TaskEntity({
//     required this.id,
//     required this.userId,
//     required this.goal,
//     required this.period,
//     required this.title,
//     required this.value,
//     required this.description,
//     required this.time,
//     required this.startDate,
//     required this.endDate,
//     required this.repeatOn,
//     required this.isActive,
//     required this.isCompleted,
//   });
//
//   factory TaskEntity.fromJson(Map<String, dynamic> json) => TaskEntity(
//     id: json['id'],
//     userId: json['userId'],
//     goal: json['goal'],
//     period: json['period'],
//     title: json['title'],
//     value: json['value'],
//     description: json['description'],
//     time: json['time'],
//     startDate: DateTime.parse(json['startDate']),
//     endDate: DateTime.parse(json['endDate']),
//     repeatOn: json['repeatOn'],
//     isActive: json['isActive'],
//     isCompleted: json['isCompleted'],
//   );
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'userId': userId,
//     'goal': goal,
//     'period': period,
//     'title': title,
//     'value': value,
//     'description': description,
//     'time': time,
//     'startDate': startDate.toIso8601String(),
//     'endDate': endDate.toIso8601String(),
//     'repeatOn': repeatOn,
//     'isActive': isActive,
//     'isCompleted': isCompleted,
//   };
// }
import 'package:hive/hive.dart';
part 'TaskEntity.g.dart'; // This is required for code generation


@HiveType(typeId: 2)
class TaskEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final int goal;

  @HiveField(3)
  final int period;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String value;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final String time; // "09:00"

  @HiveField(8)
  final DateTime startDate;

  @HiveField(9)
  final DateTime endDate;

  @HiveField(10)
  final int repeatOn; // 0-6 (Sun-Sat)

  @HiveField(11)
  bool isActive;

  @HiveField(12)
  bool isCompleted;

  TaskEntity({
    required this.id,
    required this.userId,
    required this.goal,
    required this.period,
    required this.title,
    required this.value,
    required this.description,
    required this.time,
    required this.startDate,
    required this.endDate,
    required this.repeatOn,
    this.isActive = false,
    this.isCompleted = false,
  });


  factory TaskEntity.fromJson(Map<String, dynamic> json) => TaskEntity(
    id: json['id'],
    userId: json['userId'],
    goal: json['goal'],
    period: json['period'],
    title: json['title'],
    value: json['value'],
    description: json['description'],
    time: json['time'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    repeatOn: json['repeatOn'],
    isActive: json['isActive'],
    isCompleted: json['isCompleted'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'goal': goal,
    'period': period,
    'title': title,
    'value': value,
    'description': description,
    'time': time,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'repeatOn': repeatOn,
    'isActive': isActive,
    'isCompleted': isCompleted,
  };
}
