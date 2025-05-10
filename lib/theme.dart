import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      primary: Colors.white, // kepake
      onPrimary: Colors.black, //  kepake 
      secondary: Colors.grey.shade300, // kepake
      onSecondary: Colors.grey.shade300, // kepake
      error: Colors.red.shade200, // kepake
      onError: Colors.black, // blm
      surface: Colors.grey.shade800,
      onSurface: Colors.grey.shade200,
      onTertiary: Colors.grey.shade700,
      brightness: Brightness.light,
    ));

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.grey.shade700,
      onSecondary: Colors.grey.shade800,
      error: Colors.red.shade900,
      onError: Colors.white,
      surface: Colors.grey.shade300,
      onSurface: Colors.grey.shade700,
      tertiary: Colors.red,
      onTertiary: Colors.grey.shade300,
      brightness: Brightness.dark,
    ));
