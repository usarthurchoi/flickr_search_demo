import './blocs/interesting_photo_bloc/interesting_photo_bloc.dart';
import './blocs/recent_photo_bloc/recent_photo_bloc.dart';
import './screens/flickr_home.dart';
import './services/flickr_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './blocs/flickr_bloc/flickr_bloc.dart';
import './blocs/simple_bloc_delegate.dart';
import 'screens/consts.dart';
import './utils.dart';

void main() {
  // SimpleBlocDelegate - https://pub.dev/packages/flutter_bloc
  // BlocSupervisor.delegate = SimpleBlocDelegate();

  print('test ${DateTime.now().flickrDateString()}');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) =>
            FlickrBloc(flickrSearchService: FlickrSearchService()),
      ),
      // BlocProvider(
      //   create: (context) =>
      //       RecentPhotoBloc(flickrSearchService: FlickrSearchService())
      //         ..add(RecentFlickrPhotos(
      //             page: DEFAULT_START_PAGE, per_page: DEFAULT_PER_PAGE)),
      // ),
      BlocProvider(
        create: (context) =>
            InterestingPhotoBloc(flickrSearchService: FlickrSearchService())
              ..add(FetchInterestingPhotos(
                  page: DEFAULT_START_PAGE,
                  per_page: DEFAULT_PER_PAGE,
                  date: DateTime.now().add(Duration(days: -1)))),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flickr Demo',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: FlickrHome(),
    ),
  ));
}
