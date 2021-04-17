import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:mapi/components/mangaBox.dart';
import 'package:mapi/pages/searchPage.dart';
import 'package:mapi/services/provider.dart';
import 'package:mapi/models/manga.dart';


class LibraryPage extends StatefulWidget {
  LibraryPage({Key key}) : super(key: key);

  static const String routeTitle = 'LIBRARY';
  static const String routeName = '/';

  @override
  _LibraryPageState createState() => _LibraryPageState();
}


class _LibraryPageState extends State<LibraryPage> {

  void _goToSearch() {
    Navigator.pushNamed(context, SearchPage.routeName);
  }

  @override
  void initState() {
    super.initState();
    // Allow only portrait on normal pages
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    var mangaList = Provider.of<MapiProvider>(context).getFavourites;

    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constraints) {
            int horizontalTiles;
            if (constraints.maxWidth >= 720) {
              // Big tablet
              horizontalTiles = 4;
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 720) {
              // Small Tablet
              horizontalTiles = 3;
            } else {
              // Mobile 0 - 599
              horizontalTiles = 2;
            }

            return CustomScrollView(
              slivers: <Widget>[

                // AppBar
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: true,
                  centerTitle: true,
                  title: Text(LibraryPage.routeTitle),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.add),
                      tooltip: 'Add manga',
                      onPressed: _goToSearch,
                    )
                  ]
                ),

                // Content
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: horizontalTiles,
                    childAspectRatio: 0.56,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 16.0,
                    children: mangaList.map((Manga mangaItem) {
                      return MangaBox(mangaItem);
                    }).toList(),
                  )
                ),

              ],
            );
          }
      ),
    );
  }
}
