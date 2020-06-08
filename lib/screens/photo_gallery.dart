import 'package:flickr_demo/database/favorite_photos_dao.dart';
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
  final _dao = FavoritePhotosDao();
  
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
        maxCrossAxisExtent: 100.0,
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
          final photo = widget.photos[index];
          return Stack(children: [
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                  child: Image.network(
                    photo.imageSmallSquare100,
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
                    if (await _dao.contains(photo)) {
                      print('DAO contain the photo...');
                      if (photo.isFavorite == false) {
                         print('delete the photo...');
                        await _dao.delete(photo);
                      } else {
                         print('insert the photo...');
                        await _dao.insert(photo);
                      }
                    } else {
                       print('DAO NOT contain the photo...photo.isFavorite ${photo.isFavorite}');
                      if (photo.isFavorite == true) {
                        print('insert the photo...');
                        await _dao.insert(photo);
                      }
                    }
                  },
                  child: Icon(
                    Icons.favorite,
                    color: photo.isFavorite
                        ? Colors.red
                        : Colors.grey.withOpacity(0.6),
                  )),
            ),
          ]);
        },
        // note plus one
        childCount: widget.photos.length + 1,
      ),
    );

    //});
  }

  

  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {},
        )
      ],
    );
  }
}
