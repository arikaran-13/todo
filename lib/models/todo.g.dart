// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 0;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo()
      .._taskid = fields[0] as String
      .._taskName = fields[1] as String
      .._isCompleted = fields[2] as bool
      .._isLongPress = fields[3] as bool
      .._dueDate = fields[4] as String
      .._dueTime = fields[5] as String
      .._remainderDate = fields[6] as String
      .._remainderTime = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj._taskid)
      ..writeByte(1)
      ..write(obj._taskName)
      ..writeByte(2)
      ..write(obj._isCompleted)
      ..writeByte(3)
      ..write(obj._isLongPress)
      ..writeByte(4)
      ..write(obj._dueDate)
      ..writeByte(5)
      ..write(obj._dueTime)
      ..writeByte(6)
      ..write(obj._remainderDate)
      ..writeByte(7)
      ..write(obj._remainderTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
