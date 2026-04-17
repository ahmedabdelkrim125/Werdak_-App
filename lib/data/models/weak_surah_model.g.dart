// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weak_surah_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeakSurahEntryAdapter extends TypeAdapter<WeakSurahEntry> {
  @override
  final int typeId = 2;

  @override
  WeakSurahEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeakSurahEntry(
      surahNumber: fields[0] as int,
      addedAt: fields[1] as DateTime,
      isResolved: fields[2] as bool,
      resolvedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WeakSurahEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.surahNumber)
      ..writeByte(1)
      ..write(obj.addedAt)
      ..writeByte(2)
      ..write(obj.isResolved)
      ..writeByte(3)
      ..write(obj.resolvedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeakSurahEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeakSurahSettingsAdapter extends TypeAdapter<WeakSurahSettings> {
  @override
  final int typeId = 3;

  @override
  WeakSurahSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeakSurahSettings(
      mode: fields[0] as String,
      intervalHours: fields[1] as int,
      fixedTimes: (fields[2] as List).cast<String>(),
      startHour: fields[3] as int,
      endHour: fields[4] as int,
      isEnabled: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WeakSurahSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.mode)
      ..writeByte(1)
      ..write(obj.intervalHours)
      ..writeByte(2)
      ..write(obj.fixedTimes)
      ..writeByte(3)
      ..write(obj.startHour)
      ..writeByte(4)
      ..write(obj.endHour)
      ..writeByte(5)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeakSurahSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
