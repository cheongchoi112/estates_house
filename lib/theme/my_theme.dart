import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData myTheme = ThemeData(
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.pinkAccent,
  ),
  textTheme: GoogleFonts.nunitoSansTextTheme(),
  useMaterial3: true,
);
