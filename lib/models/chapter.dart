import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'chapter.g.dart';

@HiveType(typeId: 2)
class Chapter {
  @HiveField(0)
  final String mangaUrlSafeTitle;

  @HiveField(1)
  final String number;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String date;

  Chapter({
    @required this.mangaUrlSafeTitle,
    @required this.number,
    @required this.type,
    @required this.date
  });

  /// Unique identifier for this Chapter object
  String get uid {
    return (mangaUrlSafeTitle + type + number).trim();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Chapter &&
              runtimeType == other.runtimeType &&
              uid == other.uid;

  @override
  int get hashCode => uid.hashCode;

}



