import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flickr_demo/models/flickr_photo.dart';
import 'package:flickr_demo/services/flickr_search_service.dart';

part 'flickr_event.dart';
part 'flickr_state.dart';

class FlickrBloc extends Bloc<FlickrEvent, FlickrState> {
  FlickrSearchService _flickrSearchService;

  FlickrBloc({@required FlickrSearchService flickrSearchService})
      : _flickrSearchService = flickrSearchService;
  @override
  FlickrState get initialState => FlickrEmpty();

  @override
  Stream<FlickrState> mapEventToState(
    FlickrEvent event,
  ) async* {
    if (event is SearchFlickr) {
      yield FlickrLoading();
      try {
        final results = await _flickrSearchService.searchFlickr(
          term: event.term,
          page: event.page,
          per_page: event.per_page,
        );
        yield FlickrLoaded(
          photos: results[1],
          page: event.page,
          per_page: event.per_page,
          term: event.term,
          endOfStream: results[0],
        );
      } catch (exp) {
        yield FlickrError(message: exp.toString());
      }
    }
  }
}
