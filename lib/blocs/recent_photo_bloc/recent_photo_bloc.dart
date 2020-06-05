import 'dart:async';

import '../../models/flickr_photo.dart';
import '../../services/flickr_search_service.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recent_photo_event.dart';
part 'recent_photo_state.dart';

class RecentPhotoBloc extends Bloc<RecentPhotoEvent, RecentPhotoState> {
  FlickrSearchService _flickrSearchService;

  RecentPhotoBloc({@required FlickrSearchService flickrSearchService})
      : _flickrSearchService = flickrSearchService;
  @override
  RecentPhotoState get initialState => RecentsPhotoEmpty();

  @override
  Stream<RecentPhotoState> mapEventToState(
    RecentPhotoEvent event,
  ) async* {
    if (event is SearchFlickrPopular) {
      yield RecentsPhotoLoading();
      try {
        final photos = await _flickrSearchService.popularFlickr(
          page: event.page,
          per_page: event.per_page,
        );
        yield RecentsPhotoLoaded(
          photos: photos,
          page: event.page,
          per_page: event.per_page,
        );
      } catch (exp) {
        yield RecentsPhotoError(message: exp.toString());
      }
    }
  }
}
