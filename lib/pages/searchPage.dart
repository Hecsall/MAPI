import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:mapi/models/manga.dart';
import 'package:mapi/components/mangaBox.dart';
import 'package:mapi/services/provider.dart';


class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  static const String routeTitle = 'SEARCH';
  static const String routeName = '/search';

  @override
  _SearchPageState createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {
  List<Manga> mangaList = [];
  bool loading = false;
  String searchQuery;
  String nextPageUrl;

  ScrollController scrollController = new ScrollController();
  final searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Triggered on "Search" button pressed
  void searchManga({String query}) async {

    // Remove focus from search input
    FocusScope.of(context).requestFocus(new FocusNode());
    if (searchQuery != query) {
      setState(() => loading = true );
      searchQuery = query;
      List<Manga> newMangaList = await Provider.of<MapiProvider>(context, listen: false).getMangaList(query: query);
      setState(() {
        mangaList = newMangaList;
        loading = false;
      });
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    } else {
      scrollController.animateTo(scrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

            double loaderSize = 50;
            double loaderTopPadding = (constraints.maxHeight - loaderSize) / 2;

            return CustomScrollView(
              controller: scrollController,
              slivers: loading ? [
                SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.0, loaderTopPadding, 20.0, 16.0),
                    sliver: SliverToBoxAdapter(
                      child: SpinKitFadingFour(
                        color: Colors.white,
                        size: loaderSize,
                      ),
                    )
                  )
                ] : [
                // Add the app bar to the CustomScrollView.
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: true,
                  toolbarHeight: 80,
                  title: Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (value) {
                            searchManga(query: searchController.text);
                          },
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(color: Color(0xff9a9a9a)),
                            contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            fillColor: Theme.of(context).colorScheme.surface,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => searchManga(query: searchController.text),
                              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onBackground),
                            ),
                          ),
                        )
                    )
                  ),
                ),

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
