// app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0F766E),
      secondary: Color(0xFF18B9AC),
      tertiary: Color(0xFFCCF2EA),
      surface: Color(0xFFF8FAFC),   // pengganti mainBg
      outlineVariant: Color(0xFFE2E8F0), // pengganti border
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    extensions: const [AppColors.light],
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0F766E),
      secondary: Color(0xFF18B9AC),
      tertiary: Color(0xFFCCF2EA),
      surface: Color(0xFF0F172A),
      outlineVariant: Color(0xFF334155),
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    extensions: const [AppColors.dark],
  );
}