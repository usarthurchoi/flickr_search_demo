import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/favorite_photos_dao.dart';
import '../models/flickr_photo.dart';
import '../utils.dart';
import 'consts.dart';

class PhotoGalleryView extends StatefulWidget {
  final ThumbnailSize thumbnailSize;
  final void Function() nextPageFetchCallBack;
  final void Function() notifyScrollOffset;
  final bool endOfStream;
  final List<FlickrPhoto> photos;

  PhotoGalleryView(
      {Key key,
      @required this.photos,
      @required this.nextPageFetchCallBack,
      @required this.notifyScrollOffset,
      this.endOfStream = false,
      this.thumbnailSize = ThumbnailSize.size100})
      : super(key: key);

  @override
  _PhotoGalleryViewState createState() => _PhotoGalleryViewState();
}

// https://flutter.dev/docs/cookbook/design/orientation
class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  final _dao = FavoritePhotosDao();

  @override
  Widget build(BuildContext context) {
    //return OrientationBuilder(builder: (context, orientation) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        //childAspectRatio: 4.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == widget.photos.length) {
            if (widget.endOfStream == true) {
              return null;
            } else {
              // fetch the next page
              widget.nextPageFetchCallBack();
              // Notify the scroll offset
              widget.notifyScrollOffset();
              return Container(
                width: 100,
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          final photo = widget.photos[index];
          return Stack(children: [
            Container(
              alignment: Alignment.center,

              ///
              /// https://pub.dev/packages/cached_network_image
              /// https://pub.dev/packages/flutter_cache_manager
              ///
              /// A CacheManager to download and cache files in the cache directory of
              /// the app. Various settings on how long to keep a file can be changed.
              ///
              /// It uses the cache-control http header to efficiently retrieve files.
              /// The more basic usage is explained here. See the complete docs for more info.
              ///
              /// child: Image.network(
              ///   photo.imageSmallSquare100,
              ///   fit: BoxFit.cover,
              /// ),
              ///
              child: GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: photo.imageSmallSquare100,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                  onTap: () async {
                    final url = photo.originalImage;
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  }),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  //GestureDetector same
                  onTap: () async {
                    setState(() {
                      photo.isFavorite = !photo.isFavorite;
                    });

                    // When isFavorite turned on, insert a record to sembast database.
                    // When the favorite flag turned off, check the database and remove
                    // the record if there is any
                    if (await _dao.contains(photo)) {
                      if (photo.isFavorite == false) {
                        await _dao.delete(photo);
                      } else {
                        await _dao.insert(photo);
                      }
                    } else {
                      if (photo.isFavorite == true) {
                        await _dao.insert(photo);
                      }
                    }
                    if (photo.isFavorite == true) {
                      print('try to save image ${photo.originalImage}');
                      try {
                        await saveImage(photo.originalImage);
                        print('saved image ${photo.originalImage}');
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Icon(
                    Icons.favorite,
                    color: photo.isFavorite
                        ? Colors.red
                        : Colors.red[100].withOpacity(0.7),
                  )),
            ),
          ]);
        },
        // note plus one
        childCount: widget.endOfStream
            ? widget.photos.length
            : widget.photos.length + 1,
      ),
    );
  }
}
