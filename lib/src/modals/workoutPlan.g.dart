// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workoutPlan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutPlanAdapter extends TypeAdapter<WorkoutPlan> {
  @override
  final int typeId = 0;

  @override
  WorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutPlan(
      planName: fields[0] as String,
      achievement: fields[1] as String,
      weeklySchedule: (fields[2] as Map).cast<String, String>(),
      workouts: fields[3] as WorkoutMonth,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.planName)
      ..writeByte(1)
      ..write(obj.achievement)
      ..writeByte(2)
      ..write(obj.weeklySchedule)
      ..writeByte(3)
      ..write(obj.workouts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutMonthAdapter extends TypeAdapter<WorkoutMonth> {
  @override
  final int typeId = 1;

  @override
  WorkoutMonth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutMonth(
      month1: (fields[0] as Map).map((dynamic k, dynamic v) => MapEntry(
          k as String,
          (v as List)
              .map((dynamic e) => (e as Map).cast<String, String>())
              .toList())),
      month2: (fields[1] as Map).map((dynamic k, dynamic v) => MapEntry(
          k as String,
          (v as List)
              .map((dynamic e) => (e as Map).cast<String, String>())
              .toList())),
      month3: (fields[2] as Map).map((dynamic k, dynamic v) => MapEntry(
          k as String,
          (v as List)
              .map((dynamic e) => (e as Map).cast<String, String>())
              .toList())),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutMonth obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.month1)
      ..writeByte(1)
      ..write(obj.month2)
      ..writeByte(2)
      ..write(obj.month3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutMonthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
