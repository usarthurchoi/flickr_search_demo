import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/flickr_photo.dart';

TextStyle defaultTitleStyle = GoogleFonts.lato(
    color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500);

TextStyle defaultErrorStyle = GoogleFonts.lato(
    color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold);

const int DEFAULT_START_PAGE = 1;
const int DEFAULT_PER_PAGE = 100;

const double MAX_APPBAR_EXPANDED_HEIGHT = 110.0;

enum ThumbnailSize {
  size75,
  size100,
}

const String MAIN_APPBAR_BACKGROUND = 'assets/flickr.jpg';

const Map<String, List<FlickrPhoto>> EmptyMap = <String, List<FlickrPhoto>>{};
