import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'package:mapi/models/settings.dart';
import 'package:mapi/models/manga.dart';
import 'package:mapi/models/chapter.dart';
import 'package:mapi/services/api.dart' as Api;


// Favourites Model
class MapiProvider extends ChangeNotifier {
  Box<Settings> boxSettings = Hive.box<Settings>('settings');
  Box<Manga> boxManga = Hive.box<Manga>('manga');

  // On ChangeNotifier init:
  // - create settings object if it doesn't exist;
  MapiProvider() {
    initSettings();
  }


  /// If there are no settings in db, create them.
  void initSettings() {
    if (boxSettings.isEmpty) {
      boxSettings.put('settings', Settings());
    }
  }


  /// Return list of favourites
  List<Manga> get getFavourites {
    List<Manga> dbMangas = boxManga.values.toList();
    List<Manga> _favourites = dbMangas.where((manga) => manga.isFavourite == true).toList();
    _favourites.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return _favourites;
  }


  /// Add [Manga] to favourites
  void addFavourite(Manga mangaItem) async {
    // Set [Manga] as favourite and update db
    mangaItem.isFavourite = true;
    mangaItem.save();
    notifyListeners();
  }


  // Remove [Manga] and [Chapters] from favourites
  void removeFavourite(Manga mangaItem) async {
    // Set [Manga] as not favourite and update db
    mangaItem.isFavourite = false;
    if (mangaItem.readChapters != null) {
      mangaItem.readChapters.clear();
    }
    mangaItem.save();
    notifyListeners(); // TODO: needed ?
  }


  List<Manga> getFilteredMangaList({String query}) {
    // Get saved mangas from db
    List<Manga> dbMangas = boxManga.values.toList();
    dbMangas.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    // If query is provided, return a filtered list
    if (query != null && query.length > 0) {
      return dbMangas.where((manga) => manga.title.toLowerCase().contains(query.toLowerCase())).toList();
    }
    // If no query provided, return the complete list
    return dbMangas;
  }


  Future<List<Manga>> getMangaList({String query}) async {
    Settings settings = boxSettings.get('settings');

    // If there are manga inside db, and mangaListLastUpdated date exists
    if (boxManga.values.isNotEmpty && settings.mangaListLastUpdated != null) {
      DateTime now = DateTime.now();
      DateTime timeToRefresh = settings.mangaListLastUpdated.add(new Duration(days: 1));
      // If manga list was refreshed less than 24 hours ago, return the list from db
      if (!now.isAfter(timeToRefresh)) {
        debugPrint('Return list from db');
        return getFilteredMangaList(query: query);
      }
    }

    // If:
    // - There are no manga inside db;
    // - We don't have a "last refreshed date";
    // - It's time to refresh the manga list;

    // Get full manga list from Api
    List<Manga> apiMangaList = await Api.getMangaList();
    // Save every manga to db (create or update)
    apiMangaList.forEach((element) async {
      Manga existingManga = boxManga.get(element.urlSafeTitle);
      if (existingManga != null){
        existingManga.updateFromManga(element);
        await boxManga.put(existingManga.urlSafeTitle, existingManga);
      } else {
        await boxManga.put(element.urlSafeTitle, element);
      }
    });
    // Save the current date when we have refreshed the manga list
    settings.mangaListLastUpdated = DateTime.now();
    boxSettings.put('settings', settings);
    debugPrint('Return refreshed list from db');
    debugPrint("Manga items: ${apiMangaList.length.toString()}");
    notifyListeners();
    return getFilteredMangaList(query: query);
  }


  List<String> getReadChapters(Manga mangaItem) {
    return mangaItem.readChapters ?? [];
  }


  void markAsRead(Manga mangaItem, List<Chapter> chapters, Chapter chapter, { markPrevious: false }) {
    if (markPrevious == true) {
      int currentChapterIndex = chapters.indexOf(chapter);
      for(int i = currentChapterIndex + 1; i < chapters.length; i++) {
        if (!mangaItem.readChapters.contains(chapters[i].uid)) {
          mangaItem.readChapters.add(chapters[i].uid);
        }
      }
      mangaItem.save();
    } else {
      if (!mangaItem.readChapters.contains(chapter.uid)) {
        mangaItem.readChapters.add(chapter.uid);
        mangaItem.save();
      }
    }
    notifyListeners();
  }


  void markAsNotRead(Manga mangaItem, List<Chapter> chapters, Chapter chapter, { markPrevious: false }) {
    if (markPrevious == true) {
      int currentChapterIndex = chapters.indexOf(chapter);
      for(int i = currentChapterIndex + 1; i < chapters.length; i++) {
        if (mangaItem.readChapters.contains(chapters[i].uid)) {
          mangaItem.readChapters.remove(chapters[i].uid);
        }
      }
      mangaItem.save();
    } else {
      if (mangaItem.readChapters.contains(chapter.uid)) {
        mangaItem.readChapters.remove(chapter.uid);
        mangaItem.save();
      }
    }
    notifyListeners();
  }


}