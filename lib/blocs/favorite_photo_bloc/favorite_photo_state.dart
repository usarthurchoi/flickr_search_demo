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

// class FavoriteAdded extends FavoritePhotoState {
//   final FlickrPhoto photo;

//   FavoriteAdded({this.photo});

//   @override
//   List<Object> get props => [photo];
// }

// class FavoriteRemoved extends FavoritePhotoState {
//   final FlickrPhoto photo;

//   FavoriteRemoved({this.photo});

//   @override
//   List<Object> get props => [photo];
// }