part of 'interesting_photo_bloc.dart';

abstract class InterestingPhotoEvent extends Equatable {
  const InterestingPhotoEvent();
}

class FetchInterestingPhotos extends InterestingPhotoEvent {
  final DateTime date;
  final int page;
  final int per_page;

  FetchInterestingPhotos({@required this.page, @required this.per_page, this.date});

  @override
  List<Object> get props => [page, per_page, date];

  @override
  bool get stringify => true;
}
