import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  colorScheme:  ColorScheme(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.grey.shade300,
    onSecondary:  Colors.black,
    error: Colors.red.shade200,
    onError:  Colors.black,
    surface: Colors.grey.shade400,
    onSurface:  Colors.white,
    brightness: Brightness.light,
    
  )
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  colorScheme:  ColorScheme(
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.grey.shade700,
    onSecondary:  Colors.white,
    error: Colors.red.shade900,
    onError:  Colors.white,
    surface: Colors.grey.shade800,
    onSurface:  Colors.white,
    brightness: Brightness.dark,
  )
);
