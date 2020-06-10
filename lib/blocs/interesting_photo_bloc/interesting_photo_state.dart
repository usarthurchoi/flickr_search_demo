part of 'interesting_photo_bloc.dart';

abstract class InterestingPhotoState extends Equatable {
  const InterestingPhotoState();
  @override
  List<Object> get props => [];
}

class InterestingPhotoEmpty extends InterestingPhotoState {}

class InterestingPhotoLoading extends InterestingPhotoState {}

class InterestingPhotoLoaded extends InterestingPhotoState {
  final DateTime date;
  final int page;
  final int per_page;
  final bool endOfStream;
  final List<FlickrPhoto> photos;
  InterestingPhotoLoaded(
      {@required this.photos,
      this.page,
      this.per_page,
      this.date,
      this.endOfStream});

  @override
  List<Object> get props => [photos, page, per_page, date];
}

class InterestingPhotoError extends InterestingPhotoState {
  final String message;
  InterestingPhotoError({this.message});

  @override
  List<Object> get props => [message];
}
