import 'package:flutter/material.dart';

import 'package:mapi/models/manga.dart';
import 'package:mapi/pages/mangaPage.dart';


// MangaBox Widget (Tile on the GridView)
class MangaBox extends StatefulWidget {
  final Manga mangaItem;
  MangaBox(this.mangaItem, {Key key}) : super(key: key);

  @override
  _MangaBoxState createState() => _MangaBoxState();
}


class _MangaBoxState extends State<MangaBox> {

  void openManga () async {
    await Navigator.pushNamed(context, MangaPage.routeName, arguments: widget.mangaItem);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Image
          AspectRatio(
            aspectRatio: 10 / 15, // Piú o meno buono per tutti
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 6,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () => openManga(),
                child: Image.network(
                  '${widget.mangaItem.cover}',
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: 6),

          // Title
          Padding(
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            child: Text(
              "${widget.mangaItem.title}",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),

        ]
    );
  }
}