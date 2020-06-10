import 'package:flickr_demo/blocs/favorite_photo_bloc/favorite_photo_bloc.dart';
import 'package:flickr_demo/screens/consts.dart';

import '../models/flickr_photo.dart';
import '../screens/photo_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/flickr_bloc/flickr_bloc.dart';
import 'search_history.dart';
import 'dart:math' as math;
import '../utils.dart';

class FlickrSearchHome extends StatefulWidget {
  FlickrSearchHome({Key key}) : super(key: key);

  @override
  _FlickrSearchHomeState createState() => _FlickrSearchHomeState();
}

class _FlickrSearchHomeState extends State<FlickrSearchHome>
    with AutomaticKeepAliveClientMixin<FlickrSearchHome> {
  ///
  /// AutomaticKeepAliveClientMixin
  /// https://medium.com/@diegoveloper/flutter-persistent-tab-bars-a26220d322bc
  ///

  Map<String, List<FlickrPhoto>> previousSearches =
      Map<String, List<FlickrPhoto>>();

  String _term;
  int _page;
  int _page_size;
  List<FlickrPhoto> _photos = [];
  TextEditingController _searchTextController = TextEditingController();
  ScrollController _controller;
  double _lastOffset = 0;


  bool _endOfStream = false;

  @override
  void dispose() {
    _controller?.dispose();
    _searchEntryFocus.dispose();
    super.dispose();
  }

  void fetchNextPage() {
    ++_page;
    BlocProvider.of<FlickrBloc>(context)
        .add(SearchFlickr(term: _term, page: _page, per_page: _page_size));
  }

  ///deep copy
  List<FlickrPhoto> _deepCopy(List<FlickrPhoto> orginal) {
    List<FlickrPhoto> copyList = [];
    for (var item in orginal) {
      FlickrPhoto fp = new FlickrPhoto(
        id: item.id,
        owner: item.owner,
        originalImageLink: item.originalImageLink,
        secret: item.secret,
        server: item.server,
        farm: item.farm,
        title: item.title,
        isFavorite: item.isFavorite,
      );
      copyList.add(fp);
    }
    return copyList;
  }

  void _saveSearch() {
    previousSearches[_term] = _deepCopy(_photos);
  }

  void _clearSearch() {
    if (_term != null && _term.isNotEmpty) {
      //previousSearches[_term] = _photos;
      _saveSearch();
    }
    _term = '';
    _page = DEFAULT_START_PAGE;
    _page_size = DEFAULT_PER_PAGE;
    _photos.removeRange(0, _photos.length);
  }

  void _notifyScrollOffset() {
    _lastOffset = _controller.position.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlickrBloc, FlickrState>(
      listener: (context, state) {
        if (state is FlickrLoaded) {
          setState(() {
            _photos.addAll(state.photos);
            
             _endOfStream = state.endOfStream ?? false;
          });
        } else if (state is FlickrError) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      },
      child: _buildPhotoSearchForm(context),
    );
  }

  Widget _buildPhotoSearchForm(BuildContext context) {
    return BlocBuilder<FlickrBloc, FlickrState>(
      builder: (context, state) {
        //if (state is FlickrLoaded) {
        _controller?.dispose();
        _controller = ScrollController(initialScrollOffset: _lastOffset);
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              _searchEntryFocus.requestFocus();
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
                  title: Text((_photos.length > 0)
                      ? '${_term.capitalize()} Photos'
                      : 'Photos'),
                  background:
                      Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.history),
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SearchHistory(previousSearches: previousSearches),
                    )),
                  ),
                ],
              ),
              SliverPersistentHeader(
                floating: false,
                pinned: true,
                delegate: _SearchBarHeaderDelegate(
                  minHeight: 60.0,
                  maxHeight: 70.0,
                  child: _textEntry(),
                ),
              ),
              // SliverToBoxAdapter(
              //   child: SizedBox(
              //     height: 70,
              //     child: _textEntry(),
              //   ),
              // ),
              (_photos.length > 0)
                  ? PhotoGalleryView(
                      notifyScrollOffset: _notifyScrollOffset,
                      photos: _photos,
                      nextPageFetchCallBack: fetchNextPage,
                       endOfStream: _endOfStream,
                    )
                  : SliverFillRemaining(
                      child: Container(),
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  final _searchEntryFocus = FocusNode();

  Widget _textEntry() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        focusNode: _searchEntryFocus,
        autofocus: true,
        controller: _searchTextController,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: GestureDetector(
              child: Icon(Icons.clear),
              onTap: () {
                _searchTextController.clear();
              },
            ),
            hintText: 'Photo search term',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)))),
        onSubmitted: (term) {
          _clearSearch();

          // REST the scroll offset
          _lastOffset = 0;

          _term = term;
          // Add a search event with a new term
          BlocProvider.of<FlickrBloc>(context).add(
            SearchFlickr(
              term: _term,
              page: _page,
              per_page: _page_size,
            ),
          );
          //FocusScope.of(context).requestFocus(FocusNode());
          //_searchEntryFocus.requestFocus();
        },
      ),
    );
  }
}

class _SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SearchBarHeaderDelegate({
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
  bool shouldRebuild(_SearchBarHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
