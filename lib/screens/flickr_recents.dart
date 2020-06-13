import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './consts.dart';
import '../blocs/recent_photo_bloc/recent_photo_bloc.dart';
import '../models/flickr_photo.dart';
import '../screens/photo_gallery.dart';

class FlickrRecentHome extends StatefulWidget {
  FlickrRecentHome({Key key}) : super(key: key);

  @override
  _FlickrRecentHomeState createState() => _FlickrRecentHomeState();
}

class _FlickrRecentHomeState extends State<FlickrRecentHome>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<FlickrRecentHome> {
  int _page = DEFAULT_START_PAGE;
  int _page_size = DEFAULT_PER_PAGE;

  List<FlickrPhoto> _photos = [];
  double _lastScrollOffset = 0;
  ScrollController _controller;

  bool _endOfStream = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecentPhotoBloc, RecentPhotoState>(
      listener: (context, state) {
        if (state is RecentsPhotoLoaded) {
          setState(() {
            _photos.addAll(state.photos);
            _endOfStream = state.endOfStream ?? false;
          });
        } else if (state is RecentsPhotoError) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      },
      child: BlocBuilder<RecentPhotoBloc, RecentPhotoState>(
        builder: (context, state) {
          _controller?.dispose();
          _controller =
              ScrollController(initialScrollOffset: _lastScrollOffset);
          return CustomScrollView(
            controller: _controller,
            slivers: [
              _appBarSliver(),
              (_photos.length > 0)
                  ? PhotoGalleryView(
                      photos: _photos,
                      nextPageFetchCallBack: _fetchNextPage,
                      notifyScrollOffset: _notifyScrollOffset,
                      endOfStream: _endOfStream,
                      thumbnailSize: ThumbnailSize.size75,
                      // Two sizes; 75 and 100
                    )
                  : SliverFillRemaining(
                      child: Container(),
                    ),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _appBarSliver() {
    return SliverAppBar(
      expandedHeight: MAX_APPBAR_EXPANDED_HEIGHT,
      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        title: Text(
          'Recent Photos',
          style: defaultTitleStyle,
        ),
        background: Image.asset(MAIN_APPBAR_BACKGROUND, fit: BoxFit.cover),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  /// callback for fetching the next page
  void _fetchNextPage() {
    ++_page;
    BlocProvider.of<RecentPhotoBloc>(context)
        .add(RecentFlickrPhotos(page: _page, per_page: _page_size));
  }

  void _notifyScrollOffset() {
    _lastScrollOffset = _controller.position.maxScrollExtent;
  }
}
