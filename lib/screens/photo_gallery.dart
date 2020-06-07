import 'package:flickr_demo/models/flickr_photo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'consts.dart';

class PhotoGalleryView extends StatefulWidget {
  
  final ThumbnailSize thumbnailSize;
  final void Function() nextPageFetchCallBack;
  final void Function() notifyScrollOffset;
  final List<FlickrPhoto> photos;

  PhotoGalleryView(
      {Key key,
      @required this.photos,
      @required this.nextPageFetchCallBack,
      @required this.notifyScrollOffset,
      
      this.thumbnailSize = ThumbnailSize.size100})
      : super(key: key);

  @override
  _PhotoGalleryViewState createState() => _PhotoGalleryViewState();
}

// https://flutter.dev/docs/cookbook/design/orientation
class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  

  @override
  void initState() {
    print('initstate ${DateTime.now()}');
    
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    //return OrientationBuilder(builder: (context, orientation) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: (widget.thumbnailSize == ThumbnailSize.size100)
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
            widget.notifyScrollOffset();
            return Container(width: 100, height: 100, color: Colors.yellow);
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
    );

    //});
  }
}
