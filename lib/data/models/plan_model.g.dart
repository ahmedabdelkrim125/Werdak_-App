// lib/data/models/plan_model.g.dart
//
// *** هذا الملف يتولد تلقائياً ***
// شغّل الأمر ده في الـ terminal:
//   flutter pub run build_runner build --delete-conflicting-outputs
//
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

class PlanModelAdapter extends TypeAdapter<PlanModel> {
  @override
  final int typeId = 0;

  @override
  PlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanModel(
      id: fields[0] as String,
      name: fields[1] as String,
      surahNumbers: (fields[2] as List).cast<int>(),
      totalDays: fields[3] as int,
      notificationTime: fields[4] as String,
      startDate: fields[5] as DateTime,
      days: (fields[6] as List).cast<DayEntry>(),
      isCompleted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlanModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.surahNumbers)
      ..writeByte(3)
      ..write(obj.totalDays)
      ..writeByte(4)
      ..write(obj.notificationTime)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.days)
      ..writeByte(7)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayEntryAdapter extends TypeAdapter<DayEntry> {
  @override
  final int typeId = 1;

  @override
  DayEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayEntry(
      dayNumber: fields[0] as int,
      surahNumbers: (fields[1] as List).cast<int>(),
      isCompleted: fields[2] as bool,
      completedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DayEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dayNumber)
      ..writeByte(1)
      ..write(obj.surahNumbers)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
