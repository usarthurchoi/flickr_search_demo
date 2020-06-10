import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle defaultTitleStyle = GoogleFonts.lato(
    color: Colors.white, fontSize: 24, fontWeight: FontWeight.w100);

TextStyle defaultErrorStyle = GoogleFonts.lato(
    color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold);

const int DEFAULT_START_PAGE = 1;
const int DEFAULT_PER_PAGE = 100;

enum ThumbnailSize {
  size75,
  size100,
}