import './consts.dart';
import '../blocs/recent_photo_bloc/recent_photo_bloc.dart';
import '../models/flickr_photo.dart';
import 'package:flutter/scheduler.dart';
import '../screens/photo_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlickrRecentHome extends StatefulWidget {
  final void Function(int) photoCountCallback;
  FlickrRecentHome({Key key, this.photoCountCallback}) : super(key: key);

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
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Issue the initial event for getting recent photos
      BlocProvider.of<RecentPhotoBloc>(context)
          .add(SearchFlickrPopular(page: _page, per_page: _page_size));
    });
  }

  /// callback for fetching the next page
  void _fetchNextPage() {
    ++_page;
    BlocProvider.of<RecentPhotoBloc>(context)
        .add(SearchFlickrPopular(page: _page, per_page: _page_size));
  }

  void _notifyScrollOffset(double offset) {
    _lastOffset = offset;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecentPhotoBloc, RecentPhotoState>(
      listener: (context, state) {
        if (state is RecentsPhotoLoaded) {
          setState(() {
            _photos.addAll(state.photos);
            widget.photoCountCallback(_photos.length);
          });
        }
      },
      child: BlocBuilder<RecentPhotoBloc, RecentPhotoState>(
        builder: (context, state) {
          if (state is RecentsPhotoLoaded) {
            return PhotoGalleryView(
              photos: _photos,
              nextPageFetchCallBack: _fetchNextPage,
              notifyScrollOffset: _notifyScrollOffset,
              thumbnailSize: ThumbnailSize.size75,
              scrollOffset: _lastOffset, // Two sizes; 75 and 100
            );
          }
          if (state is RecentsPhotoLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is RecentsPhotoError) {
            return Center(child: Text(state.message, style: defaultErrorStyle));
          }
          if (state is RecentsPhotoEmpty) {
            return Center(
                child: Text('Search Flickr. Enjoy!', style: defaultTitleStyle));
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
