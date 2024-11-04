import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getMaterial3Theme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue, // Materialized Design blue
      brightness: Brightness.light,
    ),
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Roboto', // Or your preferred Material 3 font
        ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    // Add more component themes as needed (e.g., ElevatedButtonThemeData, TextButtonThemeData)
  );
}

// For dark mode:
ThemeData getMaterial3DarkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Roboto',
        ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    // Add more component themes as needed
  );
}
