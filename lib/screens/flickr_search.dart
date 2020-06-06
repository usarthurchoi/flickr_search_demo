import 'package:flickr_demo/models/flickr_photo.dart';
import 'package:flutter/scheduler.dart';

import '../screens/photo_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/flickr_bloc/flickr_bloc.dart';

class FlickrSearchHome extends StatefulWidget {
  FlickrSearchHome({Key key}) : super(key: key);

  @override
  _FlickrSearchHomeState createState() => _FlickrSearchHomeState();
}

// on AutomaticKeepAliveClientMixin
// https://medium.com/@diegoveloper/flutter-persistent-tab-bars-a26220d322bc

class _FlickrSearchHomeState extends State<FlickrSearchHome>
    with AutomaticKeepAliveClientMixin<FlickrSearchHome> {
  String _term;
  int _page;
  int _page_size;
  int _totalPhotos = 0;
  List<FlickrPhoto> _photos = [];
  TextEditingController _searchTextController = TextEditingController();

  void fetchNextPage() {
    ++_page;
    BlocProvider.of<FlickrBloc>(context)
        .add(SearchFlickr(term: _term, page: _page, per_page: _page_size));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlickrBloc, FlickrState>(
      listener: (context, state) {
        if (state is FlickrLoaded) {
          print('detect listening FlickrLoaded...');
          setState(() {
            _photos.addAll(state.photos);
            _totalPhotos = _photos.length + state.photos.length;
          });
        }
      },
      child: _buildPhotoSearchForm(context),
    );
  }
  //https://www.raywenderlich.com/4324124-responsive-design-for-flutter-getting-started

  Widget _buildPhotoSearchForm(BuildContext context) {
    // https://flutter.dev/docs/cookbook/design/orientation
    return OrientationBuilder(builder: (context, orientation) {
      print('from _buildPhotoSearchForm, Orientation changed: $orientation');
      //SchedulerBinding.instance.ensureVisualUpdate();
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
                setState(() {
                  _term = term;
                  _page = 1;
                  _page_size = 100;

                  _photos.removeRange(0, _photos.length);
                });

                BlocProvider.of<FlickrBloc>(context).add(SearchFlickr(
                    term: _term, page: _page, per_page: _page_size));
              },
            ),
          ),
          BlocBuilder<FlickrBloc, FlickrState>(
            builder: (context, state) {
              if (state is FlickrLoaded) {
                print('building listening FlickrLoaded...');

                return Expanded(
                  child: PhotoGalleryView(
                    photos: _photos,
                    nextPageFetchCallBack: fetchNextPage,
                  ),
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
