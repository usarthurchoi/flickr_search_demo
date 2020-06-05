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
    with SingleTickerProviderStateMixin {
  int _page;
  int _page_size;
  int _totalPhotos;
  List<FlickrPhoto> _photos;
  TabController _tabController;

  @override
  void initState() {
    _page = 1;
    _page_size = 100;
    _totalPhotos = 0;
    _photos = [];
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<FlickrBloc>(context)
        .add(SearchFlickrPopular(page: _page, per_page: _page_size));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchNextPage() {
    ++_page;
    BlocProvider.of<FlickrBloc>(context)
        .add(SearchFlickrPopular(page: _page, per_page: _page_size));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlickrBloc, FlickrState>(
      listener: (context, state) {
        if (state is FlickrRecentsLoaded) {
          print('detect listening FlickrRecentsLoaded...');
          setState(() {
            _photos.addAll(state.photos);
            _totalPhotos = _photos.length + state.photos.length;
          });
        }
      },
      child: BlocBuilder<FlickrBloc, FlickrState>(
        builder: (context, state) {
          if (state is FlickrRecentsLoaded) {
            print('building listening FlickrRecentsLoaded...');

            return PhotoGalleryView(
              photos: _photos,
              nextPageFetchCallBack: fetchNextPage,
              thumbnailSize: ThumbnailSize.size75,
            );
          }
          if (state is FlickrLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is FlickrError) {
            return Text(state.message);
          }
          if (state is FlickrEmpty) {
            return Text('Search Flickr. Enjoy!');
          } else if (state is FlickrLoaded) {
            return Text('Humm ignore this');
          }
        },
      ),
    );
  }
}
