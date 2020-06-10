part of 'recent_photo_bloc.dart';

abstract class RecentPhotoState extends Equatable {
  const RecentPhotoState();
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class RecentsPhotoEmpty extends RecentPhotoState {}

class RecentsPhotoLoading extends RecentPhotoState {}

class RecentsPhotoLoaded extends RecentPhotoState {
  final int page;
  final int per_page;
  final bool endOfStream;
  final List<FlickrPhoto> photos;
  RecentsPhotoLoaded({@required this.photos, this.page, this.per_page, this.endOfStream});

  @override
  List<Object> get props => [photos, page, per_page];
}

class RecentsPhotoError extends RecentPhotoState {
  final String message;
  RecentsPhotoError({this.message});

  @override
  List<Object> get props => [message];
}
