import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.interTextTheme(),
    colorScheme: ColorScheme(
      primary: Colors.white, // kepake
      onPrimary: Colors.black, //  kepake 
      secondary: Colors.grey.shade300, // kepake
      error: Colors.red.shade200, // kepake
      onError: Colors.black, // blm
      surface: Colors.grey.shade800,
      outline: Colors.grey.shade500,
      surfaceBright: Colors.grey.shade300,
      onSecondary: Colors.grey.shade400, // kepake
      onSurface: Colors.grey.shade200,
      onTertiary: Colors.grey.shade700,
      brightness: Brightness.light, 
      primaryContainer: Colors.grey.shade100,

      inversePrimary: Colors.grey.shade900,
      onInverseSurface: Colors.grey.shade600,

      //fab shadow
      shadow: Colors.grey.shade300
    ));

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    textTheme: GoogleFonts.interTextTheme(),
    colorScheme: ColorScheme(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.grey.shade700,
      onSecondary: Colors.grey.shade800,
      error: Colors.red.shade900,
      outline: Colors.grey.shade800,
      surfaceBright: Colors.grey.shade700,
      onError: Colors.white,
      surface: Colors.grey.shade300,
      onSurface: Colors.grey.shade800,
      tertiary: Colors.red,
      onTertiary: Colors.grey.shade400,
      brightness: Brightness.dark,
      primaryContainer: Colors.grey.shade900,
      // enabledBorder
      inversePrimary: Colors.grey.shade600,
      onInverseSurface: Colors.grey.shade300,
      
      shadow: Colors.grey.shade800
    ));
