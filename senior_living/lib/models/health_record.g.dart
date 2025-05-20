// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthRecordAdapter extends TypeAdapter<HealthRecord> {
  @override
  final int typeId = 1;

  @override
  HealthRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthRecord(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      bloodPressure: fields[2] as String?,
      spo2: fields[3] as int?,
      bloodSugar: fields[4] as int?,
      notes: fields[5] as String?,
      cholesterol: fields[6] as int?,
      uricAcid: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.bloodPressure)
      ..writeByte(3)
      ..write(obj.spo2)
      ..writeByte(4)
      ..write(obj.bloodSugar)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.cholesterol)
      ..writeByte(7)
      ..write(obj.uricAcid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
