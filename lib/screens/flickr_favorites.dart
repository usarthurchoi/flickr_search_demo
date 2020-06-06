import 'package:flickr_demo/blocs/recent_photo_bloc/recent_photo_bloc.dart';
import 'package:flickr_demo/models/flickr_photo.dart';
import 'package:flutter/scheduler.dart';

import '../screens/photo_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/flickr_bloc/flickr_bloc.dart';

class FlickrRecentHome extends StatefulWidget {
  FlickrRecentHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlickrRecentHomeState createState() => _FlickrRecentHomeState();
}

class _FlickrRecentHomeState extends State<FlickrRecentHome>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<FlickrRecentHome> {
  int _page;
  int _page_size;
  int _totalPhotos;
  List<FlickrPhoto> _photos;

  @override
  void initState() {
    _page = 1;
    _page_size = 100;
    _totalPhotos = 0;
    _photos = [];
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<RecentPhotoBloc>(context)
          .add(SearchFlickrPopular(page: _page, per_page: _page_size));
    });
  }

  void fetchNextPage() {
    ++_page;
    BlocProvider.of<RecentPhotoBloc>(context)
        .add(SearchFlickrPopular(page: _page, per_page: _page_size));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecentPhotoBloc, RecentPhotoState>(
      listener: (context, state) {
        if (state is RecentsPhotoLoaded) {
          print('detect listening FlickrRecentsLoaded...');
          setState(() {
            _photos.addAll(state.photos);
            _totalPhotos = _photos.length + state.photos.length;
          });
        }
      },
      child: BlocBuilder<RecentPhotoBloc, RecentPhotoState>(
        builder: (context, state) {
          if (state is RecentsPhotoLoaded) {
            print('building listening FlickrRecentsLoaded...');

            return PhotoGalleryView(
              photos: _photos,
              nextPageFetchCallBack: fetchNextPage,
              thumbnailSize: ThumbnailSize.size75,
            );
          }
          if (state is RecentsPhotoLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is RecentsPhotoError) {
            return Text(state.message);
          }
          if (state is RecentsPhotoEmpty) {
            return Text('Search Flickr. Enjoy!');
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
