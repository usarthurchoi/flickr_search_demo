import './consts.dart';
import '../blocs/recent_photo_bloc/recent_photo_bloc.dart';
import '../models/flickr_photo.dart';
import 'package:flutter/scheduler.dart';
import '../screens/photo_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  double _lastOffset = 0;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Issue the initial event for getting recent photos
      BlocProvider.of<RecentPhotoBloc>(context)
          .add(SearchFlickrPopular(page: _page, per_page: _page_size));
    });
    // Note To control the initial scroll offset of the scroll view, provide a
    // controller with its ScrollController.initialScrollOffset property set.
  }

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
            //widget.photoCountCallback(_photos.length);
          });
        }
      },
      child: BlocBuilder<RecentPhotoBloc, RecentPhotoState>(
        builder: (context, state) {
          if (state is RecentsPhotoLoaded) {
            _controller?.dispose();
            _controller = ScrollController(initialScrollOffset: _lastOffset);
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  _onStartScroll(scrollNotification.metrics);
                } else if (scrollNotification is ScrollUpdateNotification) {
                  _onUpdateScroll(scrollNotification.metrics);
                } else if (scrollNotification is ScrollEndNotification) {
                  _onEndScroll(scrollNotification.metrics);
                }
              },
              child: CustomScrollView(
                controller: _controller,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    floating: false,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: [StretchMode.zoomBackground],
                      title: Text('#${_photos.length}'),
                      background:
                          Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  PhotoGalleryView(
                    photos: _photos,
                    nextPageFetchCallBack: _fetchNextPage,
                    notifyScrollOffset: _notifyScrollOffset,
                    thumbnailSize: ThumbnailSize.size75,
                    // Two sizes; 75 and 100
                  ),
                ],
              ),
            );
          }
          if (state is RecentsPhotoLoading) {
            return _screenWith(Center(child: CircularProgressIndicator()));
            //return Center(child: CircularProgressIndicator());
          }
          if (state is RecentsPhotoError) {
            return _screenWith(
                Center(child: Text(state.message, style: defaultErrorStyle)));
          }
          if (state is RecentsPhotoEmpty) {
            return _screenWith(Center(
                child:
                    Text('Search Flickr. Enjoy!', style: defaultTitleStyle)));
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _onStartScroll(ScrollMetrics metrics) {
    // setState(() {
    //   message = "Scroll Start";
    // });
    //print('_onStartScroll lastoffset = $_lastOffset  _controller.offset ${_controller.offset}');
  }
  _onUpdateScroll(ScrollMetrics metrics) {
    // setState(() {
    //   message = "Scroll Update";
    // });
    //print('_onUpdateScroll lastoffset = $_lastOffset  _controller.offset ${_controller.offset}');
  }
  _onEndScroll(ScrollMetrics metrics) {
    // setState(() {
    //   message = "Scroll End";
    // });
    //_lastOffset = _controller.offset;
    // print('_onEndScroll lastoffset = $_lastOffset  _controller.offset ${_controller.offset}');
  }

  /// callback for fetching the next page
  void _fetchNextPage() {
    ++_page;
    BlocProvider.of<RecentPhotoBloc>(context)
        .add(SearchFlickrPopular(page: _page, per_page: _page_size));
  }

  void _notifyScrollOffset() {
    _lastOffset = _controller.position.maxScrollExtent;
  }

  Widget _screenWith(Widget child) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [StretchMode.zoomBackground],
            //title: Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
            background: Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
          ),
        ),
        SliverFillRemaining(
          child: child,
        ),
      ],
    );
  }
}
