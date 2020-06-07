import 'dart:convert';

import '../models/flickr_photo.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class FlickrSearchService {
  // need api_key, page, per_page, text additional parameters
  static const String _frickrSearchURL =
      'https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=$key&format=json&nojsoncallback=1&safe_search=1&extras=url_o';

  static const String _frickrPopularURL =
      'https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=$key&format=json&nojsoncallback=1&safe_search=1&extras=url_o';

  /// 5ed037a790604180e8709935f3023575
  ///
  /// Secret:
  /// 139436c0d12c98e8

  static const key =
      '5ed037a790604180e8709935f3023575'; //'1b94d66369b01f348f6270e37f9e4623';

  String _searchEndPoint({@required String term, int page, int per_page}) {
    assert(per_page <= 500);
    return '${FlickrSearchService._frickrSearchURL}&page=$page&per_page=$per_page&text=$term';
  }

  String _popularEndPoint({int page, int per_page}) {
    assert(per_page <= 500);
    return '${FlickrSearchService._frickrPopularURL}&page=$page&per_page=$per_page';
  }

  Future<List<FlickrPhoto>> searchFlickr(
      {@required String term, int page = 1, int per_page = 100}) async {
    
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Flickr rejected my request to access this method
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    // Number of photos to return per page. If this argument is omitted,
    // it defaults to 100. The maximum allowed value is 500.
    //final url = _searchEndPoint(term: term, page: page, per_page: per_page);
    final url = _popularEndPoint(page: page, per_page: per_page);
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    final response = await http.get(url);

    final jsonResult = jsonDecode(response.body);
    try {
      // {"photos":{"page":130,"pages":799,"perpage":100,"total":"79837","photo":[{"id":"49973748432",

      // [{"id":"49973748432",
      // "owner":"188751975@N02",
      // "secret":"55eff4ecdc",
      // "server":"65535",
      // "farm":66,
      // "title":"2","ispublic":1,"isfriend":0,"isfamily":0}
      //print(response.body);
      final jsonPhotos = jsonResult['photos']['photo'] as List<dynamic>;
      return jsonPhotos
          .map((jsonPhoto) =>
              FlickrPhoto.fromJson(jsonPhoto as Map<String, dynamic>))
          .toList();
    } catch (error) {
      final msg = jsonResult['message'] ?? error.toString();
      throw 'HTTP status ${response.statusCode} and $msg';
    }
  }

  Future<List<FlickrPhoto>> popularFlickr(
      {int page = 1, int per_page = 100}) async {
    // Number of photos to return per page. If this argument is omitted,
    // it defaults to 100. The maximum allowed value is 500.
    final url = _popularEndPoint(page: page, per_page: per_page);
    
    final response = await http.get(url);

    final jsonResult = jsonDecode(response.body);
    try {
      // {"photos":{"page":130,"pages":799,"perpage":100,"total":"79837","photo":[{"id":"49973748432",

      // [{"id":"49973748432",
      // "owner":"188751975@N02",
      // "secret":"55eff4ecdc",
      // "server":"65535",
      // "farm":66,
      // "title":"2","ispublic":1,"isfriend":0,"isfamily":0}
      //print(response.body);
      final jsonPhotos = jsonResult['photos']['photo'] as List<dynamic>;
      return jsonPhotos
          .map((jsonPhoto) =>
              FlickrPhoto.fromJson(jsonPhoto as Map<String, dynamic>))
          .toList();
    } catch (error) {
      final msg = jsonResult['message'] ?? error.toString();
      throw 'HTTP status ${response.statusCode} and $msg';
    }
  }
}
