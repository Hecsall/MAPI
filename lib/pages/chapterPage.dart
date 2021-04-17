import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import 'package:mapi/models/chapter.dart';
import 'package:mapi/services/provider.dart';
import 'package:mapi/models/manga.dart';
import 'package:mapi/services/api.dart' as Api;


class ChapterPage extends StatefulWidget {
  final ChapterArguments args;
  ChapterPage(this.args, {Key key}) : super(key: key);

  static String routeName = '/chapter';

  @override
  _ChapterPageState createState() => _ChapterPageState();
}


class _ChapterPageState extends State<ChapterPage> {
  int length = 0;
  int currentPage = 1;
  List<dynamic> pages;
  bool appBarVisible = true;
  bool chapterAndPageVisible = true;
  bool loading = true;

  void fetchPages() async {
    List<dynamic> newPages = await Api.getPages(widget.args.mangaItem.urlSafeTitle, widget.args.chapter.number);
    setState(() {
      pages = newPages;
      length = newPages.length;
      loading = false;
    });
  }

  void toggleAppBar () {
    setState(() {
      appBarVisible = !appBarVisible;
    });
  }

  void setCurrentPage (int page) {
    if (page == 0 || page == length + 1) {
      if(page == length + 1) {
        // Set current chapter as read
        Provider.of<MapiProvider>(context, listen: false).markAsRead(widget.args.mangaItem, widget.args.chapters, widget.args.chapter);
      }
      setState(() {
        chapterAndPageVisible = false;
      });
    } else {
      setState(() {
        currentPage = page;
        chapterAndPageVisible = true;
      });
    }
  }

  void _goToPreviousChapter () async {
    List<Chapter> allChapters = widget.args.chapters;
    Chapter currentChapter = allChapters.firstWhere((elem) =>
      elem == widget.args.chapter
    );
    int currentIndex = allChapters.indexOf(currentChapter);
    if (currentIndex+1 < allChapters.length) {
      Chapter previousChapter = allChapters[allChapters.indexOf(currentChapter) + 1];
      await Navigator.pushReplacementNamed(
        context, ChapterPage.routeName, arguments: ChapterArguments(
          widget.args.mangaItem, widget.args.chapters, previousChapter
        )
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("No chapter found"),
            actions: <Widget>[
              TextButton(
                child: Text('Oof'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
          );
        }
      );
    }
  }

  void _goToNextChapter () async {
    List<dynamic> allChapters = widget.args.chapters;
    Chapter currentChapter = allChapters.firstWhere((elem) =>
      elem == widget.args.chapter
    );
    int currentIndex = allChapters.indexOf(currentChapter);
    if (currentIndex-1 > -1) {
      Chapter nextChapter = allChapters[allChapters.indexOf(currentChapter) - 1];
      await Navigator.pushReplacementNamed(
          context, ChapterPage.routeName, arguments: ChapterArguments(
          widget.args.mangaItem, widget.args.chapters, nextChapter
        )
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("No chapter found"),
            actions: <Widget>[
              TextButton(
                child: Text('Oof'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
          );
        }
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Allow all view orientations on reader page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    fetchPages();
  }

  @override
  void dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Loading...', style: TextStyle(color: Colors.white),)
        ],
      )
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return Center(
        child: PageView.builder(
          // store this controller in a State to save the carousel scroll position
          controller: PageController(viewportFraction: 1, initialPage: 1),
          onPageChanged: (value) => setCurrentPage(value),

          itemCount: length + 2,
          itemBuilder: (BuildContext context, int itemIndex) {
            return _buildCarouselItem(context, itemIndex);
          },
        )
    );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex) {
    if (itemIndex == 0) {
      // Go to previous chapter page
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            color: Colors.transparent,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
            splashColor: Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: Colors.white)
            ),
            onPressed: () => _goToPreviousChapter(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, size: 25),
                VerticalDivider(width: 10,),
                Text(
                  "Previous Chapter",
                  style: TextStyle(fontSize: 17.0),
                ),
              ]
            )
          ),
        ],
      );
    } else if (itemIndex == length + 1) {
      // Go to next chapter page
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            color: Colors.transparent,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
            splashColor: Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: Colors.white)
            ),
            onPressed: () => _goToNextChapter(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Next Chapter",
                  style: TextStyle(fontSize: 17.0),
                ),
                VerticalDivider(width: 10,),
                Icon(Icons.arrow_forward, size: 25),
              ]
            )
          )
        ],
      );
    } else {
      // Manga Page
      return Container(
        child: Padding(
          padding: EdgeInsets.all(1),
          child: PhotoView(
            minScale: PhotoViewComputedScale.contained * 1,
            maxScale: PhotoViewComputedScale.contained * 2.5,
            imageProvider: NetworkImage(pages[itemIndex-1]),
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: appBarVisible ? AppBar(
        title: chapterAndPageVisible ? Text("Chapter ${widget.args.chapter.number}") : null,
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        centerTitle: true,
        primary: true,
        actions: chapterAndPageVisible ? <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 16.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    children: <TextSpan>[
                      TextSpan(text: '$currentPage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                      TextSpan(text: ' / $length'),
                    ],
                  ),
                ),
              ],
            )
          )
        ] : null
      ) : null,
      body: GestureDetector(
        onTap: () => setState(() => appBarVisible = !appBarVisible),
        child: Column(
          children: [
            Expanded(
              child: loading ? _buildLoading(context) :_buildCarousel(context)
            )
          ]
        )
      )
    );
  }
}
