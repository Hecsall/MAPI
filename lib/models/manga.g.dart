// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MangaAdapter extends TypeAdapter<Manga> {
  @override
  final int typeId = 0;

  @override
  Manga read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Manga(
      title: fields[0] as String,
      urlSafeTitle: fields[1] as String,
      cover: fields[2] as String,
      categories: (fields[3] as List)?.cast<dynamic>(),
      status: fields[4] as String,
      isFavourite: fields[5] as bool,
      readChapters: (fields[6] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Manga obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.urlSafeTitle)
      ..writeByte(2)
      ..write(obj.cover)
      ..writeByte(3)
      ..write(obj.categories)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.isFavourite)
      ..writeByte(6)
      ..write(obj.readChapters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MangaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
