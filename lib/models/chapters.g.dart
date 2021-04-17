// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChaptersAdapter extends TypeAdapter<Chapters> {
  @override
  final int typeId = 1;

  @override
  Chapters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chapters(
      list: (fields[0] as List)?.cast<Chapter>(),
      readChapters: (fields[1] as List)?.cast<Chapter>(),
    );
  }

  @override
  void write(BinaryWriter writer, Chapters obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.list)
      ..writeByte(1)
      ..write(obj.readChapters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChaptersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
