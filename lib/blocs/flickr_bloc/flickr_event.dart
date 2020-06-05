part of 'flickr_bloc.dart';

abstract class FlickrEvent extends Equatable {
  const FlickrEvent();
}

class SearchFlickr extends FlickrEvent {
  final int page;
  final int per_page;
  final String term;

  SearchFlickr(
      {@required this.term, @required this.page, @required this.per_page});

  @override
  List<Object> get props => [term, page, per_page];

  @override
  bool get stringify => true;
}
