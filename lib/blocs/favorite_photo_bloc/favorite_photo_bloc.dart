import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flickr_demo/database/favorite_photos_dao.dart';
import 'package:flickr_demo/models/flickr_photo.dart';

part 'favorite_photo_event.dart';
part 'favorite_photo_state.dart';

class FavoritePhotoBloc extends Bloc<FavoritePhotoEvent, FavoritePhotoState> {
  final _dao = FavoritePhotosDao();

  @override
  FavoritePhotoState get initialState => FavoritePhotoLoading();

  @override
  Stream<FavoritePhotoState> mapEventToState(
    FavoritePhotoEvent event,
  ) async* {
    if (event is GetFavoritePhotos) {
      yield FavoritePhotoLoading();
      yield* _reloadFavorites();
    }
    if (event is AddFavoritePhoto) {
      await _dao.insert(event.photo);
      yield* _reloadFavorites();
    }
    if (event is UpdateFavoritePhoto) {
      await _dao.update(event.photo);
      yield* _reloadFavorites();
    }
    if (event is DeleteFavoritePhoto) {
      await _dao.delete(event.photo);
      yield* _reloadFavorites();
    }
  }

  Stream<FavoritePhotoState> _reloadFavorites() async* {
    final photos = await _dao.getFavoritePhotos();
    yield FavoritePhotoLoaded(photos: photos);
  }
}
