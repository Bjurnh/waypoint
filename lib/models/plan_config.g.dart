// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanConfigAdapter extends TypeAdapter<PlanConfig> {
  @override
  final int typeId = 1;

  @override
  PlanConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanConfig(
      length: fields[0] as int,
      startDate: fields[1] as DateTime,
      style: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlanConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.length)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.style);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
