part of 'favorite_photo_bloc.dart';

abstract class FavoritePhotoState extends Equatable {
  const FavoritePhotoState();
}

class FavoritePhotoLoading extends FavoritePhotoState {
  @override
  List<Object> get props => [];
}

class FavoritePhotoLoaded extends FavoritePhotoState {
  final List<FlickrPhoto> photos;

  FavoritePhotoLoaded({this.photos});

  @override
  List<Object> get props => [photos];
}
