import 'package:flickr_demo/screens/consts.dart';

import '../models/flickr_photo.dart';
import '../screens/photo_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/flickr_bloc/flickr_bloc.dart';

class FlickrSearchHome extends StatefulWidget {
  final void Function(int) photoCountCallback;
  FlickrSearchHome({Key key, this.photoCountCallback}) : super(key: key);

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

  double _lastOffset = 0;

  void fetchNextPage() {
    ++_page;
    BlocProvider.of<FlickrBloc>(context)
        .add(SearchFlickr(term: _term, page: _page, per_page: _page_size));
  }

  void _saveSearch() {
    previousSearches[_term] = _photos;
  }

  void _clearSearch() {
    _term = '';
    _page = DEFAULT_START_PAGE;
    _page_size = DEFAULT_PER_PAGE;
    _photos.removeRange(0, _photos.length);
  }

  void _notifyScrollOffset(double offset) {
    _lastOffset = offset;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlickrBloc, FlickrState>(
      listener: (context, state) {
        if (state is FlickrLoaded) {
          setState(() {
            _photos.addAll(state.photos);
            widget.photoCountCallback(_photos.length);
          });
        }
      },
      child: _buildPhotoSearchForm(context),
    );
  }

  Widget _buildPhotoSearchForm(BuildContext context) {
    // https://flutter.dev/docs/cookbook/design/orientation
    return OrientationBuilder(builder: (context, orientation) {
      print('from _buildPhotoSearchForm, Orientation changed: $orientation');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
                // Add a search event with a new term
                BlocProvider.of<FlickrBloc>(context).add(
                  SearchFlickr(
                    term: _term,
                    page: _page,
                    per_page: _page_size,
                  ),
                );
              },
            ),
          ),
          BlocBuilder<FlickrBloc, FlickrState>(
            builder: (context, state) {
              if (state is FlickrLoaded) {
                return Expanded(
                  child: PhotoGalleryView(
                    notifyScrollOffset: _notifyScrollOffset,
                    scrollOffset: _lastOffset,
                    photos: _photos,
                    nextPageFetchCallBack: fetchNextPage,
                  ),
                );
              }
              if (state is FlickrLoading) {
                return Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }
              if (state is FlickrError) {
                return Expanded(child: Center(child: Text(state.message)));
              }
              if (state is FlickrEmpty) {
                return Expanded(
                    child: Center(child: Text('Search Flickr. Enjoy!')));
              } else {
                return Container();
              }
            },
          ),
        ],
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
