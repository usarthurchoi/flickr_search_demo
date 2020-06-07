import './blocs/recent_photo_bloc/recent_photo_bloc.dart';
import './screens/flickr_home.dart';
import './services/flickr_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './blocs/flickr_bloc/flickr_bloc.dart';
import './blocs/simple_bloc_delegate.dart';

void main() {
  // SimpleBlocDelegate - https://pub.dev/packages/flutter_bloc 
  BlocSupervisor.delegate = SimpleBlocDelegate();
  
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
