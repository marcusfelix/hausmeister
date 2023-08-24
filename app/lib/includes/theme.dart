import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ColorScheme _scheme = ColorScheme(
//   brightness: Brightness.light, 
//   primary: Colors.blueGrey.shade700,
//   onPrimary: Colors.white, 
//   primaryContainer: Colors.blueGrey.shade100,
//   onPrimaryContainer: Colors.blueGrey.shade800,
//   secondary: Colors.cyan,
//   onSecondary: Colors.white, 
//   secondaryContainer: Colors.cyan.shade100,
//   onSecondaryContainer: Colors.cyan.shade800,
//   tertiary: Colors.blueGrey.shade800,
//   onTertiary: Colors.black,
//   tertiaryContainer: Colors.blueGrey.shade100,
//   onTertiaryContainer: Colors.blueGrey.shade800,
//   error: Colors.red, 
//   onError: Colors.white, 
//   background: Colors.white, 
//   onBackground: Colors.black, 
//   surface: Colors.blue.shade100,
//   onSurface: Colors.blue.shade800,
// );

ColorScheme _scheme = ColorScheme.fromSeed(seedColor: Colors.redAccent);

ThemeData _theme = ThemeData.from(
  colorScheme: _scheme
);

final theme = _theme.copyWith(
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    backgroundColor: _scheme.background,
    titleTextStyle: TextStyle(
      color: _scheme.primary,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -1
    ),
    iconTheme: IconThemeData(
      color: _scheme.primary,
    ),
    centerTitle: false
  ),
  textTheme: GoogleFonts.interTextTheme(_theme.textTheme),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: _scheme.onPrimaryContainer,
        width: 2.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: _scheme.primaryContainer,
        width: 2.0,
      ),
    ),
  ),
  tabBarTheme: const TabBarTheme(
    indicator: BoxDecoration(),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 0,
    focusElevation: 0.0,
    hoverElevation: 0.0,
    disabledElevation: 0.0,
    highlightElevation: 0.0,
  ),
  popupMenuTheme: PopupMenuThemeData(
    elevation: 0,
    color: _scheme.primaryContainer,
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: _scheme.onPrimaryContainer
    )
  )
);