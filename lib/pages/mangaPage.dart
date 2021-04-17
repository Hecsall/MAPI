import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:mapi/components/colors.dart';
import 'package:mapi/models/chapter.dart';
import 'package:mapi/services/provider.dart';
import 'package:mapi/models/manga.dart';
import 'package:mapi/pages/chapterPage.dart';
import 'package:mapi/services/api.dart' as Api;


enum MoreActions { markAsRead, markPreviousAsRead, markAsNotRead, markPreviousAsNotRead }


class MangaPage extends StatefulWidget {
  final Manga mangaItem;
  MangaPage(this.mangaItem, {Key key}) : super(key: key);

  static const String routeTitle = 'MANGA';
  static const String routeName = '/manga';

  @override
  _MangaPageState createState() => _MangaPageState();
}


class _MangaPageState extends State<MangaPage> {
  List<Chapter> chapters = [];
  bool favouriteButtonEnabled = false;
  bool loading = true;

  void _toggleFavourite (BuildContext context) async {
    if (widget.mangaItem.isFavourite) {
      Provider.of<MapiProvider>(context, listen: false).removeFavourite(widget.mangaItem);
    } else {
      Provider.of<MapiProvider>(context, listen: false).addFavourite(widget.mangaItem);
    }
    setState(() { });
  }

  void _openChapter(Chapter chapter) async {
    await Navigator.pushNamed(context, ChapterPage.routeName, arguments: ChapterArguments(widget.mangaItem, chapters, chapter));
  }

  void fetchList() async {
    chapters = await Api.getChapters(widget.mangaItem.urlSafeTitle);
    setState(() {
      loading = false;
      favouriteButtonEnabled = true;
    });
  }

  void _handleMoreAction(choice, Chapter chapter) {
    if (choice == MoreActions.markAsRead) {
      Provider.of<MapiProvider>(context, listen: false).markAsRead(widget.mangaItem, chapters, chapter);
    } else if (choice == MoreActions.markPreviousAsRead) {
      Provider.of<MapiProvider>(context, listen: false).markAsRead(widget.mangaItem, chapters, chapter, markPrevious: true);
    } else if (choice == MoreActions.markAsNotRead) {
      Provider.of<MapiProvider>(context, listen: false).markAsNotRead(widget.mangaItem, chapters, chapter);
    } else if (choice == MoreActions.markPreviousAsNotRead) {
      Provider.of<MapiProvider>(context, listen: false).markAsNotRead(widget.mangaItem, chapters, chapter, markPrevious: true);
    }
    setState(() { });
  }

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  @override
  Widget build(BuildContext context) {
    var isFavourite = widget.mangaItem.isFavourite;
    List<String> readChapters = Provider.of<MapiProvider>(context).getReadChapters(widget.mangaItem);
    double chapterItemHeight = 50.0;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double columnWidth;
          double coverWidth;
          double topSectionHeight;
          if (constraints.maxWidth >= 720) {
            // Big tablet
            columnWidth = MediaQuery.of(context).size.width / 2.5;
            coverWidth = MediaQuery.of(context).size.width / 2.5;
            topSectionHeight = MediaQuery.of(context).size.height * 0.65;
          } else if (constraints.maxWidth > 600 && constraints.maxWidth < 720) {
            // Small Tablet
            columnWidth = MediaQuery.of(context).size.width / 2.5;
            coverWidth = MediaQuery.of(context).size.width / 2.5;
            topSectionHeight = MediaQuery.of(context).size.height * 0.66;
          } else {
            // Mobile 0 - 599
            columnWidth = MediaQuery.of(context).size.width / 1.4;
            coverWidth = MediaQuery.of(context).size.width / 2.3;
            topSectionHeight = MediaQuery.of(context).size.height * 0.69;
          }

          double loaderSize = 50;

          return CustomScrollView(
            slivers: <Widget>[

              // AppBar
              SliverAppBar(
                bottom: PreferredSize(
                  child: Container(),
                  // Force the minimum "extended" appbar height
                  preferredSize: Size(0, topSectionHeight - 56), // 56 is the appbar height
                ),
                pinned: false,
                expandedHeight: topSectionHeight,
                centerTitle: true,
                title: Text(MangaPage.routeTitle),
                actions: [
                  IconButton(
                    icon: Icon(isFavourite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded
                    ),
                    tooltip: isFavourite
                      ? 'Remove from favourites'
                      : 'Add to favourites',
                    onPressed: () => favouriteButtonEnabled
                        ? _toggleFavourite(context)
                        : null,
                  )
                ],
                flexibleSpace: Stack(
                  alignment: Alignment.center,
                  children: [

                    // Blurred Image
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.mangaItem.cover),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                          child: Container(
                            color: Theme.of(context).colorScheme.background.withOpacity(0.75),
                          ),
                        ),
                      ),
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0
                    ),

                    // Bottom rounded corners
                    Positioned(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40),
                          ),
                        ),
                      ),
                      bottom: -1,
                      left: 0,
                      right: 0,
                    ),


                    // Real content of the top section
                    SizedBox(
                        width: columnWidth, // Limit width of the content
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                          SizedBox(height: 110,),
                          // Cover
                          SizedBox(
                            width: coverWidth,
                            child: AspectRatio(
                              aspectRatio: 10 / 15,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 6,
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  child: Image.network(
                                    widget.mangaItem.cover,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null)
                                        return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          ),

                          SizedBox(height: 20),

                          // Title
                          Text(
                            widget.mangaItem.title,
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center
                          ),

                          SizedBox(height: 10),

                          // Status
                          Text(
                          widget.mangaItem.status,
                          style: TextStyle(
                            fontSize: 15,
                            color: StatusColors[widget.mangaItem.status.toLowerCase()],
                            fontWeight: FontWeight.w500
                          ),
                          textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 10),

                          Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 5.0,
                            spacing: 5.0,
                            children:widget.mangaItem.categories.map((dynamic element) {
                              return SizedBox(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Text(element, style: TextStyle(fontSize: 12))
                                ),
                              );
                            }).toList()
                          )

                        ],
                      ),
                    ),


                  ],
                ),
              ),

              // Chapter list
              loading ?
              SliverToBoxAdapter(
                child: SpinKitFadingFour(
                  color: Colors.white,
                  size: loaderSize,
                ),
              ) :
              SliverFixedExtentList(
                itemExtent: chapterItemHeight,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    DateTime date = DateTime.parse(chapters[index].date);
                    bool isRead = readChapters.contains(chapters[index].uid);

                    return InkWell(
                      onTap: () => _openChapter(chapters[index]),
                      child: Column(
                        children: [
                          SizedBox(
                              width: 320,
                              height: chapterItemHeight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${chapters[index].type} ${chapters[index].number}',
                                      style: TextStyle(
                                          color: isRead ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onBackground,
                                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    isFavourite ? PopupMenuButton<MoreActions>(
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onBackground),
                                      onSelected: (MoreActions choice) {
                                        _handleMoreAction(choice, chapters[index]);
                                      },
                                      itemBuilder: (context) => isRead ? [
                                        PopupMenuItem(
                                          value: MoreActions.markAsNotRead,
                                          child: Text("Mark as not read"),
                                        ),
                                        PopupMenuItem(
                                          value: MoreActions.markPreviousAsNotRead,
                                          child: Text("Mark previous as not read"),
                                        ),
                                      ] : [
                                        PopupMenuItem(
                                          value: MoreActions.markAsRead,
                                          child: Text("Mark as read"),
                                        ),
                                        PopupMenuItem(
                                          value: MoreActions.markPreviousAsRead,
                                          child: Text("Mark previous as read"),
                                        ),
                                      ],
                                    ) : SizedBox()
                                  ],
                                )
                          ),
                        ],
                      )
                    );
                  },
                  childCount: chapters != null ? chapters.length : 0,
                ),
              ),

            ]
          );
        }
      )
    );
  }
}
