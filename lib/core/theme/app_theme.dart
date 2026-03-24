/// **Architecture Layer**: Core
/// **Purpose**: Application styling and theming.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
        surfaceContainer: const Color(0xFFF5F5F5), // Light grey for background
        primary: const Color(0xFF2E7D32), // Dark Green
        secondary: const Color(0xFF4CAF50), // Light Green
        tertiary: const Color(0xFFFF9800), // Orange
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
        surfaceContainer: const Color(0xFF1E1E1E), // Dark grey for background
        primary: const Color(0xFF81C784), // Light Green
        secondary: const Color(0xFF66BB6A), // Green
        tertiary: const Color(0xFFFFB74D), // Light Orange
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
