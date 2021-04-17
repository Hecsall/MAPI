import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
// Pages
import 'package:mapi/pages/libraryPage.dart';
import 'package:mapi/pages/searchPage.dart';
import 'package:mapi/pages/mangaPage.dart';
import 'package:mapi/pages/chapterPage.dart';
import 'package:mapi/services/provider.dart';
import 'package:mapi/components/appTheme.dart';
import 'package:mapi/models/settings.dart';
import 'package:mapi/models/manga.dart';
import 'package:mapi/models/chapters.dart';
import 'package:mapi/models/chapter.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Settings>(SettingsAdapter());
  Hive.registerAdapter<Manga>(MangaAdapter());
  Hive.registerAdapter<Chapters>(ChaptersAdapter());
  Hive.registerAdapter<Chapter>(ChapterAdapter());
  await Hive.openBox<Settings>('settings');
  await Hive.openBox<Manga>('manga');
  runApp(MAPI());
}


class MAPI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapiProvider()),
      ],
      child: MaterialApp(
        title: 'MAPI',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: primaryTheme('light'),
        darkTheme: primaryTheme('dark'),

        // Routing
        initialRoute: LibraryPage.routeName,
        onGenerateRoute: (RouteSettings settings) {
          var routes = <String, WidgetBuilder>{
            LibraryPage.routeName:  (context) => LibraryPage(),
            SearchPage.routeName:   (context) => SearchPage(),
            MangaPage.routeName:    (context) => MangaPage(settings.arguments),
            ChapterPage.routeName:  (context) => ChapterPage(settings.arguments),
          };
          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (context) => builder(context));
        },

      )
    );
  }
}