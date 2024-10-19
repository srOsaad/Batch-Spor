// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassAdapter extends TypeAdapter<ClassDetails> {
  @override
  final int typeId = 0;

  @override
  ClassDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassDetails(
      cw: fields[0] as String,
      hw: fields[1] as String,
      offlineExam: fields[2] as String,
      onlineExam: fields[3] as String,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ClassDetails obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.cw)
      ..writeByte(1)
      ..write(obj.hw)
      ..writeByte(2)
      ..write(obj.offlineExam)
      ..writeByte(3)
      ..write(obj.onlineExam)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BatchAdapter extends TypeAdapter<Batch> {
  @override
  final int typeId = 1;

  @override
  Batch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Batch(
      nameLowerCase: fields[0] as String,
      database: fields[1] as String,
      name: fields[2] as String,
      days: (fields[3] as List).cast<int>(),
      clasS: fields[4] as int,
      classDateTime: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Batch obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nameLowerCase)
      ..writeByte(1)
      ..write(obj.database)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.days)
      ..writeByte(4)
      ..write(obj.clasS)
      ..writeByte(5)
      ..write(obj.classDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
