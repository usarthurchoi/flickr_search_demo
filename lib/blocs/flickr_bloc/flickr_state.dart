part of 'flickr_bloc.dart';

abstract class FlickrState extends Equatable {
  const FlickrState();
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FlickrEmpty extends FlickrState {}

class FlickrLoading extends FlickrState {}

class FlickrLoaded extends FlickrState {
  final String term;
  final int page;
  final int per_page;
  final bool endOfStream;
  final List<FlickrPhoto> photos;
  FlickrLoaded({@required this.photos, this.term, this.page, this.per_page, this.endOfStream});

  @override
  List<Object> get props => [photos, term, page, per_page];
}

class FlickrError extends FlickrState {
  final String message;
  FlickrError({this.message});

  @override
  List<Object> get props => [message];
}
