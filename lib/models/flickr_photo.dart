import 'package:uuid/uuid.dart';

final Uuid _uuid = Uuid();

class FlickrPhoto {
  String uuid;
  final String id;
  final String owner;
  final String secret;
  final String server;
  final int farm;
  final String title;
  final String originalImageLink;

  bool isFavorite;

  FlickrPhoto({
    this.uuid,
    this.id,
    this.owner,
    this.secret,
    this.server,
    this.farm,
    this.title,
    this.originalImageLink,
    this.isFavorite = false,
  }) {
    if (uuid == null) {
      uuid = _uuid.v4();
    }
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'FlickrPhoto $uuid';
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'id': id,
      'owner': owner,
      'secret': secret,
      'server': server,
      'farm': farm,
      'title':title,
      'originalImageLink': originalImageLink,
      'isFavorite': isFavorite,
    };
  }

  static FlickrPhoto fromJson(Map<String, dynamic> json) {
    return FlickrPhoto(
      uuid: json['uuid'] ?? _uuid.v4(),
      title: json['title'] ?? '',
      id: json['id'],
      owner: json['owner'],
      secret: json['secret'],
      farm: json['farm'],
      server: json['server'],
      originalImageLink: json['url_o'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  String get originalImage {
    //print('original $originalImageLink');
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
