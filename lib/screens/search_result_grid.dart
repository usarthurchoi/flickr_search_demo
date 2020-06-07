import 'package:flickr_demo/models/flickr_photo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'consts.dart';

class SearchResultSliverGrid extends StatelessWidget {
  final String searchTerm;
  final List<FlickrPhoto> photos;
  final ThumbnailSize thumbnailSize;
  const SearchResultSliverGrid(
      {Key key,
      @required this.searchTerm,
      @required this.photos,
      this.thumbnailSize = ThumbnailSize.size100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.zoomBackground],
              title: Text(searchTerm),
              background: Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
            ),
          ),
          SliverGrid(
            gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  (thumbnailSize == ThumbnailSize.size100) ? 100 : 75,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 1.0,
            ),
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final photo = photos[index];
                return Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      child: Image.network(
                        photo.imageSmallSquare100,
                        fit: BoxFit.cover,
                      ),
                      onTap: () async {
                        final url = photo.originalImage;
                        print('passing $url');
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      }),
                );
              },
              childCount: photos.length,
            ),
          ),
        ],
      ),
    );
  }
}
