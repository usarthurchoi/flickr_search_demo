import 'package:flickr_demo/blocs/recent_photo_bloc/recent_photo_bloc.dart';

import './screens/flickr_search.dart';
import './services/flickr_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './blocs/flickr_bloc/flickr_bloc.dart';
import './blocs/simple_bloc_delegate.dart';
import 'screens/flickr_favorites.dart';

void main() {
  //BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) =>
            FlickrBloc(flickrSearchService: FlickrSearchService()),
      ),
      BlocProvider(
        create: (context) =>
            RecentPhotoBloc(flickrSearchService: FlickrSearchService()),
      ),
    ],
    child: MaterialApp(
      title: 'Flickr Demo',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: FlickrHome(),
    ),
  ));
}

class FlickrHome extends StatelessWidget {
  FlickrHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flickr'),
          bottom: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.amber,
              tabs: [
                Tab(icon: Icon(Icons.watch), text: 'Recent Upload',),
                Tab(icon: Icon(Icons.search), text: 'Search',),
              ]),
        ),
        body: TabBarView(
          children: [
            FlickrRecentHome(),
            FlickrSearchHome(),
          ],
        ),
      ),
    );
  }
}
