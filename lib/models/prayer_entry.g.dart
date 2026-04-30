// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerEntryAdapter extends TypeAdapter<PrayerEntry> {
  @override
  final int typeId = 2;

  @override
  PrayerEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerEntry(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      category: fields[3] as String?,
      dateAdded: fields[4] as DateTime,
      isAnswered: fields[5] as bool,
      answeredDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.dateAdded)
      ..writeByte(5)
      ..write(obj.isAnswered)
      ..writeByte(6)
      ..write(obj.answeredDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
