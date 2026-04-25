import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors - Neon Mochi / Electric Marshmallow
  static const Color primary = Color(0xFFFF85FF); // Bubblegum Pink / Neon Pink
  static const Color primaryContainer = Color(0xFFE972EA);
  static const Color secondary = Color(0xFFEDE59D); // Pastel Yellow
  static const Color tertiary = Color(0xFF8FF5FF); // Cyan / Neon Spark

  // Backgrounds - Deep plum midnight
  static const Color backgroundLight = Color(0xFFFFF8F9); // Inverse Surface
  static const Color surfaceLight = Colors.white;
  
  static const Color backgroundDark = Color(0xFF20021A); // Deep plum midnight
  static const Color surfaceDark = Color(0xFF20021A);
  
  // Tonal Layering
  static const Color surfaceContainerLow = Color(0xFF280521);
  static const Color surfaceContainerHigh = Color(0xFF3A0E30);
  static const Color surfaceContainerHighest = Color(0xFF421338);

  // Text colors
  static const Color textPrimary = Color(0xFFFFDCF0); // Light pinkish-white
  static const Color textSecondary = Color(0xFFCF9CBC); // Muted pink
  static const Color textDark = Color(0xFF20021A);

  // Status colors
  static const Color error = Color(0xFFFF6E84);
  static const Color success = Color(0xFF4CAF50); // Not specified in palette, keep standard
  static const Color warning = Color(0xFFEDE59D);
  static const Color info = Color(0xFF8FF5FF);
}
