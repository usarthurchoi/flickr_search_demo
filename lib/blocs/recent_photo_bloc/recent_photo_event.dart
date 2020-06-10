part of 'recent_photo_bloc.dart';

abstract class RecentPhotoEvent extends Equatable {
  const RecentPhotoEvent();
}

class RecentFlickrPhotos extends RecentPhotoEvent {
  final int page;
  final int per_page;

  RecentFlickrPhotos({@required this.page, @required this.per_page});

  @override
  List<Object> get props => [page, per_page];

  @override
  bool get stringify => true;
}
