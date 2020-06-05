import 'package:equatable/equatable.dart';

class FlickrPhoto extends Equatable {
  final String id;
  final String owner;
  final String secret;
  final String server;
  final int farm;
  final String title;
  final String originalImageLink;

  FlickrPhoto({
    this.id,
    this.owner,
    this.secret,
    this.server,
    this.farm,
    this.title,
    this.originalImageLink,
  });

  @override
  List<Object> get props => [id, title, server, farm, owner, secret];

  @override
  bool get stringify => true;

  static FlickrPhoto fromJson(Map<String, dynamic> json) {
    return FlickrPhoto(
      title: json['title'] ?? '',
      id: json['id'],
      owner: json['owner'],
      secret: json['secret'],
      farm: json['farm'],
      server: json['server'],
      originalImageLink: json['url_o'],
    );
  }

  String get originalImage {
    print('original $originalImageLink');
    return originalImageLink ?? imageLarge;
  }

  String get imageThumbnail =>
      'http://farm$farm.static.flickr.com/$server/$id\_$secret\_t.jpg';
  String get imageSmallSquare75 =>
      'http://farm$farm.static.flickr.com/$server/$id\_$secret\_s.jpg';
  String get imageSmallSquare100 =>
      'http://farm$farm.static.flickr.com/$server/$id\_$secret\_q.jpg';
  String get imageMidium240 =>
      'http://farm$farm.static.flickr.com/$server/$id\_$secret\_m.jpg';
  String get imageMidium640 =>
      'http://farm$farm.static.flickr.com/$server/$id\_$secret\_z.jpg';
  String get imageLarge =>
      'http://farm$farm.static.flickr.com/$server/$id\_$secret\_b.jpg';
}
