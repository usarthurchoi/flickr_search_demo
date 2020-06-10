import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flickr_demo/services/flickr_search_service.dart';
import '../../models/flickr_photo.dart';
import 'package:meta/meta.dart';


part 'interesting_photo_event.dart';
part 'interesting_photo_state.dart';

class InterestingPhotoBloc extends Bloc<InterestingPhotoEvent, InterestingPhotoState> {
  FlickrSearchService _flickrSearchService;

  InterestingPhotoBloc({@required FlickrSearchService flickrSearchService})
      : _flickrSearchService = flickrSearchService;
  @override
  InterestingPhotoState get initialState => InterestingPhotoEmpty();

  @override
  Stream<InterestingPhotoState> mapEventToState(
    InterestingPhotoEvent event,
  ) async* {
    if (event is FetchInterestingPhotos) {
      yield InterestingPhotoLoading();
      try {
        final results = await _flickrSearchService.interestingPhotoFlickr(
          page: event.page,
          per_page: event.per_page,
          date: event.date,
        );
        print('results => $results');
        yield InterestingPhotoLoaded(
          photos: results[1],
          page: event.page,
          per_page: event.per_page,
          date: event.date,
          endOfStream: results[0],
        );
      } catch (exp) {
        print(exp.toString());
      
        yield InterestingPhotoError(message: exp.toString());
      }
    }
  }
}
