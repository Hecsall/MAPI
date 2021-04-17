import 'dart:convert';
import 'package:web_scraper/web_scraper.dart';

import 'package:mapi/models/chapter.dart';
import 'package:mapi/models/manga.dart';


final String apiBaseUrl = 'https://mangasee123.com';


/// Converts a [chapter] to a zero padded number.
///
/// If [chapter] is an integer will return: 0015
/// If [chapter] is decimal, will return: 0015.5
String padChapter (String chapter) {
  if(chapter.contains('.')) {
    return chapter.padLeft(6, '0');
  } else {
    return chapter.padLeft(4, '0');
  }
}


/// Removes zero-padding from [chapter].
///
/// Recursive function that keeps removing leading "0" until there are no more.
/// If the final string is empty, it returns "0" (It will be empty if the
/// chapter number is actually "0" and it gets deleted by the function).
/// Returns the chapter without zero-padding.
String removeChapterPad (String chapter) {
  if(chapter.startsWith('0')) {
    return removeChapterPad(chapter.substring(1, chapter.length));
  }
  return chapter.length > 0 ? chapter : '0';
}


/// Converts "MangaSee chapter formatting" to a readable chapter number.
///
/// Chapter formatting:
/// ```
/// eg. 109565 -> [1] [0956] [5]      -> Chapter 956.5
///                ?   chap.  decimal
/// ```
/// [chapter] is the chapter number formatted from MangaSee's website.
/// Returns a readable chapter number.
String processChapterNumber (String chapter) {
  String decimalNumber = chapter.substring(chapter.length-1, chapter.length);
  String decimal = decimalNumber != '0' ? '.$decimalNumber' : '';
  String integer = removeChapterPad(chapter.substring(1, chapter.length-1));
  return integer + decimal;
}


/// Get list of mangas.
///
/// Get all mangas found on MangaSee.
/// Returns a list of [Manga] objects.
Future<List<Manga>> getMangaList() async {
  final webScraper = WebScraper(apiBaseUrl);
  /// List to be returned at the end
  List<Manga> _mangaList = [];

  if (await webScraper.loadWebPage('/search/')) {

    // Get the JSON list of manga
    Map<String, dynamic> elements = webScraper.getScriptVariables(['vm.Directory']);
    String scrapedString = elements['vm.Directory'][0].replaceAll('vm.Directory = ', '');
    String response = scrapedString.substring(0, scrapedString.length - 1);
    List<dynamic> jsonResponse = jsonDecode(response);

    // Create Manga items and add them to the list
    jsonResponse.forEach((mangaObject) {
      Manga manga = Manga(
          title: mangaObject['s'],
          urlSafeTitle: mangaObject['i'],
          cover: 'https://cover.nep.li/cover/${mangaObject['i']}.jpg',
          categories: mangaObject['g'],
          status: mangaObject['ss'],
          readChapters: []
      );
      _mangaList.add(manga);
    });
  }
  return _mangaList;
}


/// Gets a list of chapters of a given manga.
///
/// [urlSafeTitle] is the [Manga.urlSafeTitle].
/// Returns a list of [Chapter].
Future<List<Chapter>> getChapters(String urlSafeTitle) async {
  final webScraper = WebScraper(apiBaseUrl);
  // List to be returned at the end
  List<Chapter> _chaptersList = [];

  if (await webScraper.loadWebPage('/manga/$urlSafeTitle')) {
    // Get the JSON list of manga
    Map<String, dynamic> elements = webScraper.getScriptVariables(['vm.Chapters']);
    String scrapedString = elements['vm.Chapters'][0].replaceAll('vm.Chapters = ', '');
    String response = scrapedString.substring(0, scrapedString.length - 1);
    List<dynamic> jsonResponse = jsonDecode(response);

    // Create Chapter items and add them to the list
    jsonResponse.forEach((chapterObject) {
      Chapter chapter = Chapter(
        mangaUrlSafeTitle: urlSafeTitle,
        number: processChapterNumber(chapterObject['Chapter']),
        type: chapterObject['Type'],
        date: chapterObject['Date'],
      );
      _chaptersList.add(chapter);
    });
  }
  return _chaptersList;
}


/// Gets a list of pages.
///
/// [urlSafeTitle] is the [Manga.urlSafeTitle], [chapter] is the [Chapter.number].
/// Returns a list containing every page's image url.
Future<List<String>> getPages(String urlSafeTitle, String chapter) async {
  final webScraper = WebScraper(apiBaseUrl);
  /// List to be returned at the end
  List<String> _pagesList = [];

  if (await webScraper.loadWebPage('/read-online/$urlSafeTitle-chapter-$chapter-page-1.html')) {
    // Get server url
    Map<String, dynamic> elementsServer = webScraper.getScriptVariables(['vm.CurPathName']);
    String scrapedStringServer = elementsServer['vm.CurPathName'][0].replaceAll('vm.CurPathName = ', '');
    String responseServer = scrapedStringServer.substring(1, scrapedStringServer.length - 2);

    // Get the JSON list of pages
    Map<String, dynamic> elements = webScraper.getScriptVariables(['vm.CurChapter']);
    String scrapedString = elements['vm.CurChapter'][0].replaceAll('vm.CurChapter = ', '');
    String response = scrapedString.substring(0, scrapedString.length - 1);
    Map<String, dynamic> jsonResponse = jsonDecode(response);

    // Create Chapter items and add them to the list
    String pathName = responseServer;
    String paddedChapterNumber = padChapter(chapter);
    String directory = jsonResponse['Directory'].length > 0 ? jsonResponse['Directory'] + '/' : '';
    for(int page = 1; page <= int.parse(jsonResponse['Page']); page++) {
      String paddedPageNumber = page.toString().padLeft(3, '0');
      String pageUrl = 'https://$pathName/manga/$urlSafeTitle/$directory$paddedChapterNumber-$paddedPageNumber.png';
      _pagesList.add(pageUrl);
    }
  }
  return _pagesList;
}