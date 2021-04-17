import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'chapter.dart';

part 'chapters.g.dart';

@HiveType(typeId: 1)
class Chapters extends HiveObject {

  @HiveField(0)
  List<Chapter> list;

  @HiveField(1)
  final List<Chapter> readChapters;

  Chapters({
    @required this.list,
    this.readChapters
  });
}



