import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'chapter.dart';

part 'manga.g.dart';

@HiveType(typeId: 0)
class Manga extends HiveObject {

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String urlSafeTitle;

  @HiveField(2)
  String cover;

  @HiveField(3)
  final List<dynamic> categories;

  @HiveField(4)
  String status;

  @HiveField(5)
  bool isFavourite;

  @HiveField(6)
  List<String> readChapters;

  Manga({
    @required this.title,
    @required this.urlSafeTitle,
    @required this.cover,
    @required this.categories,
    @required this.status,
    this.isFavourite: false,
    this.readChapters
  });

  void updateFromManga (Manga mangaToCopy) {
    cover = mangaToCopy.cover;
    status = mangaToCopy.status;
  }

  // void updateChapters (List<Chapter> newChapters) {
  //   // If no chapters already saved inside this Manga, add them.
  //   if (chapters.isEmpty) {
  //     chapters = newChapters;
  //   } else {
  //     // If Manga has saved chapters, add only the missing ones.
  //     newChapters.forEach((chapter) {
  //       if (!chapters.contains(chapter)) {
  //         debugPrint('Adding newly found chapter ${chapter.number}');
  //         chapters.add(chapter);
  //       }
  //     });
  //   }
  // }
}


// Arguments Manga related
class ChapterArguments {
  Manga mangaItem;
  List<dynamic> chapters;
  Chapter chapter;

  ChapterArguments(this.mangaItem, this.chapters, this.chapter);
}


