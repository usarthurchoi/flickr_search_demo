import '../blocs/interesting_photo_bloc/interesting_photo_bloc.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import './consts.dart';
import '../blocs/recent_photo_bloc/recent_photo_bloc.dart';
import '../models/flickr_photo.dart';
import '../screens/photo_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import '../utils.dart';

class FlickrInterestingHome extends StatefulWidget {
  FlickrInterestingHome({Key key}) : super(key: key);

  @override
  _FlickrInterestingHomeState createState() => _FlickrInterestingHomeState();
}

class _FlickrInterestingHomeState extends State<FlickrInterestingHome>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<FlickrInterestingHome> {
  int _page = DEFAULT_START_PAGE;
  int _page_size = DEFAULT_PER_PAGE;
  DateTime _selectedDate = DateTime.now().add(Duration(days: -1));

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
    return BlocListener<InterestingPhotoBloc, InterestingPhotoState>(
      listener: (context, state) {
        if (state is InterestingPhotoLoaded) {
          setState(() {
            _photos.addAll(state.photos);
            _endOfStream = state.endOfStream ?? false;
            //widget.photoCountCallback(_photos.length);
          });
        } else if (state is InterestingPhotoError) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      },
      child: BlocBuilder<InterestingPhotoBloc, InterestingPhotoState>(
        builder: (context, state) {
          _controller?.dispose();
          _controller =
              ScrollController(initialScrollOffset: _lastScrollOffset);
          return CustomScrollView(
            controller: _controller,
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [StretchMode.zoomBackground],
                  title: Text('Interesting Photos'),
                  background:
                      Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
                ),
              ),
              SliverPersistentHeader(
                floating: false,
                pinned: true,
                delegate: _TimeLinePickerHeaderDelegate(
                  minHeight: 80.0,
                  maxHeight: 80.0,
                  child: DatePicker(
                    DateTime.now().add(Duration(days: -30)), // start day
                    daysCount: 30,
                    initialSelectedDate: _selectedDate,
                    selectionColor: Colors.black,
                    selectedTextColor: Colors.white,
                    onDateChange: (date) {
                      // New date selected
                      setState(() {
                        // if a different date
                        if (date.flickrDateString() !=
                            _selectedDate.flickrDateString()) {
                               _photos = [];
                            _lastScrollOffset = 0;
                          _selectedDate = date;
                          BlocProvider.of<InterestingPhotoBloc>(context).add(
                              FetchInterestingPhotos(
                                  page: DEFAULT_START_PAGE,
                                  per_page: DEFAULT_PER_PAGE,
                                  date: date));
                        } else {
                          // ignore it
                        }
                      });
                    },
                  ),
                ),
              ),
              (_photos.length > 0)
                  ? PhotoGalleryView(
                      photos: _photos,
                      nextPageFetchCallBack: _fetchNextPage,
                      notifyScrollOffset: _notifyScrollOffset,
                      thumbnailSize: ThumbnailSize.size75,
                      endOfStream: _endOfStream,
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

  @override
  bool get wantKeepAlive => true;

  /// callback for fetching the next page
  void _fetchNextPage() {
    ++_page;
    BlocProvider.of<InterestingPhotoBloc>(context).add(FetchInterestingPhotos(
        page: _page, per_page: _page_size, date: _selectedDate));
  }

  void _notifyScrollOffset() {
    _lastScrollOffset = _controller.position.maxScrollExtent;
  }
}

class _TimeLinePickerHeaderDelegate extends SliverPersistentHeaderDelegate {
  _TimeLinePickerHeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_TimeLinePickerHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
