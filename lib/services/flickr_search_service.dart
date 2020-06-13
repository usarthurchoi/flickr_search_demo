import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../models/flickr_photo.dart';
import '../utils.dart';

class FlickrSearchService {
  // need api_key, page, per_page, text additional parameters
  static const String _frickrSearchURL =
      'https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=$key&format=json&nojsoncallback=1&safe_search=1&extras=url_o';

  static const String _frickrRecentPhotosURL =
      'https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=$key&format=json&nojsoncallback=1&safe_search=1&extras=url_o';

  static const String _frickrInterestingPhotosURL =
      'https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=$key&format=json&nojsoncallback=1&safe_search=1&extras=url_o';

  /// 5ed037a790604180e8709935f3023575
  ///
  /// Secret:
  /// 139436c0d12c98e8

  static const key =
      '5ed037a790604180e8709935f3023575'; //'1b94d66369b01f348f6270e37f9e4623';

  String _searchEndPoint({@required String term, int page, int per_page}) {
    assert(per_page <= 500);
    final encodedParam = Uri.encodeFull(
        '${FlickrSearchService._frickrSearchURL}&page=$page&per_page=$per_page&text=$term');
    return encodedParam;
  }

  String _recentPhotosEndPoint({int page, int per_page}) {
    assert(per_page <= 500);
    return '${FlickrSearchService._frickrRecentPhotosURL}&page=$page&per_page=$per_page';
  }

  String _interestingPhotosEndPoint({int page, int per_page, DateTime date}) {
    assert(per_page <= 500);
    return '${FlickrSearchService._frickrInterestingPhotosURL}&page=$page&per_page=$per_page&date=${date.flickrDateString()}';
  }

  Future<List<dynamic>>  searchFlickr(
      {@required String term, int page = 1, int per_page = 100}) async {
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Flickr rejected my request to access this method
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    // Number of photos to return per page. If this argument is omitted,
    // it defaults to 100. The maximum allowed value is 500.
    final url = _searchEndPoint(term: term, page: page, per_page: per_page);
    //final url = _popularEndPoint(page: page, per_page: per_page);
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    final response = await http.get(url);

    try {
      return compute(parseResponse2, response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>>  recentPhotosFlickr(
      {int page = 1, int per_page = 100}) async {
    // Number of photos to return per page. If this argument is omitted,
    // it defaults to 100. The maximum allowed value is 500.
    final url = _recentPhotosEndPoint(page: page, per_page: per_page);

    final response = await http.get(url);

    try {
      return compute(parseResponse2, response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> interestingPhotoFlickr(
      {int page = 1, int per_page = 100, DateTime date}) async {
    // Number of photos to return per page. If this argument is omitted,
    // it defaults to 100. The maximum allowed value is 500.
    //final url = _recentPhotosEndPoint(page: page, per_page: per_page);
    if (date == null) {
      date = TODAY;
    }
    final url =
        _interestingPhotosEndPoint(page: page, per_page: per_page, date: date);
    print('$url');
    final response = await http.get(url);

    try {
      return compute(parseResponse2, response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

// top level
List<FlickrPhoto> parseResponse(String responseString) {
  print('processing from a separate isolate');
  final jsonResult = jsonDecode(responseString);
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
    throw '$msg';
  }
}

// top level
List<dynamic> parseResponse2(String responseString) {
  final jsonResult = jsonDecode(responseString);
  try {
    var endOfStream = false;
    int totalPages = jsonResult['photos']['pages'];
    int currentPage = jsonResult['photos']['page'];
    if (currentPage == totalPages) {
      // end of photo stream
      print('Okay it is the end!!!!');
      endOfStream = true;
    }
    final jsonPhotos = jsonResult['photos']['photo'] as List<dynamic>;
    return <dynamic>[
      endOfStream,
      jsonPhotos
          .map((jsonPhoto) =>
              FlickrPhoto.fromJson(jsonPhoto as Map<String, dynamic>))
          .toList()
    ];
  } catch (error) {
    final msg = jsonResult['message'] ?? error.toString();
    throw '$msg';
  }
}
