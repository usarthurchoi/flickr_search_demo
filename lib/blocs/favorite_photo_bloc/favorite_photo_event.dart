part of 'favorite_photo_bloc.dart';

abstract class FavoritePhotoEvent extends Equatable {
  const FavoritePhotoEvent();
}

class AddFavoritePhoto extends FavoritePhotoEvent {
  final FlickrPhoto photo;
  AddFavoritePhoto({this.photo});

  @override
  List<Object> get props => [photo];
}

class DeleteFavoritePhoto extends FavoritePhotoEvent {
  final FlickrPhoto photo;
  DeleteFavoritePhoto({this.photo});

  @override
  List<Object> get props => [photo];
}

class UpdateFavoritePhoto extends FavoritePhotoEvent {
  final FlickrPhoto photo;
  UpdateFavoritePhoto({this.photo});

  @override
  List<Object> get props => [photo];
}

class GetFavoritePhotos extends FavoritePhotoEvent {
  final List<FlickrPhoto> photos;

  GetFavoritePhotos({this.photos});

  @override
  // TODO: implement props
  List<Object> get props => [photos];
}
