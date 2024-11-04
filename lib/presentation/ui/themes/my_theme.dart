import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getMaterial3Theme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      bodyLarge: GoogleFonts.roboto(fontSize: 16),
      bodyMedium: GoogleFonts.roboto(fontSize: 14),
      titleLarge: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );
}

ThemeData getMaterial3DarkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
      bodyLarge: GoogleFonts.roboto(fontSize: 16),
      bodyMedium: GoogleFonts.roboto(fontSize: 14),
      titleLarge: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );
}
