import 'package:flutter/material.dart';
import 'package:xfood/core/theme/app_colors.dart';

class AppTypography {
  // We use Plus Jakarta Sans for Hero/Headers, Be Vietnam Pro for Body
  static const String headlineFontFamily = 'Plus Jakarta Sans';
  static const String bodyFontFamily = 'Be Vietnam Pro';

  static const TextStyle h1 = TextStyle(
    fontFamily: headlineFontFamily,
    fontSize: 40, // display-lg
    fontWeight: FontWeight.w900, // The Bold Editorial
    color: AppColors.textPrimary,
    letterSpacing: -0.8, // tight letter-spacing
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: headlineFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: headlineFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14, // body-md
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle button = TextStyle(
    fontFamily: headlineFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark, // On Primary is dark plum
  );
}
