// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listening_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListeningEventAdapter extends TypeAdapter<ListeningEvent> {
  @override
  final int typeId = 1;

  @override
  ListeningEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListeningEvent(
      songTitle: fields[0] as String,
      timestamp: fields[1] as DateTime,
      durationMinutes: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ListeningEvent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.songTitle)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.durationMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListeningEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
