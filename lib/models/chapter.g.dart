// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChapterAdapter extends TypeAdapter<Chapter> {
  @override
  final int typeId = 2;

  @override
  Chapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chapter(
      mangaUrlSafeTitle: fields[0] as String,
      number: fields[1] as String,
      type: fields[2] as String,
      date: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Chapter obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.mangaUrlSafeTitle)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
