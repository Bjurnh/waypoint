// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_reading.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayReadingAdapter extends TypeAdapter<DayReading> {
  @override
  final int typeId = 0;

  @override
  DayReading read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayReading(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      chapters: (fields[2] as List).cast<String>(),
      completed: fields[3] as bool,
      completionDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DayReading obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.chapters)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.completionDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayReadingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
