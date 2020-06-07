import 'package:flickr_demo/models/flickr_photo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'consts.dart';

class PhotoGalleryView extends StatefulWidget {
  final double scrollOffset;
  final ThumbnailSize thumbnailSize;
  final void Function() nextPageFetchCallBack;
  final void Function(double) notifyScrollOffset;
  final List<FlickrPhoto> photos;

  PhotoGalleryView(
      {Key key,
      @required this.photos,
      @required this.nextPageFetchCallBack,
      @required this.notifyScrollOffset,
      this.scrollOffset = 0.0,
      this.thumbnailSize = ThumbnailSize.size100})
      : super(key: key);

  @override
  _PhotoGalleryViewState createState() => _PhotoGalleryViewState();
}

// https://flutter.dev/docs/cookbook/design/orientation
class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  ScrollController _controller;

  @override
  void initState() {
    print('initstate ${DateTime.now()}');
    // Note To control the initial scroll offset of the scroll view, provide a 
    // controller with its ScrollController.initialScrollOffset property set.
    _controller = ScrollController(initialScrollOffset: widget.scrollOffset);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return CustomScrollView(
        controller: _controller,
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  (widget.thumbnailSize == ThumbnailSize.size100)
                      ? 100
                      : 75, //extent, //200.0,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              //childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == widget.photos.length) {
                  // fetch the next page
                  widget.nextPageFetchCallBack();
                  // Notify the scroll offset
                  widget.notifyScrollOffset(_controller.offset);
                  return Container(
                      width: 100, height: 100, color: Colors.yellow);
                }
                final fp = widget.photos[index];
                return Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      child: Image.network(
                        fp.imageSmallSquare100,
                        fit: BoxFit.cover,
                      ),
                      onTap: () async {
                        final url = fp.originalImage;
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      }),
                );
              },
              // note plus one
              childCount: widget.photos.length + 1,
            ),
          ),
        ],
      );
    });
  }
}
