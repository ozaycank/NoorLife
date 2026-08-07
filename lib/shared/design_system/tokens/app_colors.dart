import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Semantic Tokens (M3)
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryContainer = Color(0xFFA5D6A7);
  static const Color secondary = Color(0xFFC99700);
  static const Color secondaryContainer = Color(0xFFFFE082);

  // Surface & Neutrals
  static const Color surface = Color(0xFFFBFDFB);
  static const Color surfaceContainer = Color(0xFFF1F5F1);
  static const Color surfaceVariant = Color(0xFFE0E5E0);
  static const Color outline = Color(0xFF707971);

  // Status & Feedback
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFED6C02);
  static const Color success = Color(0xFF2E7D32);
  static const Color info = Color(0xFF0288D1);

  // Backwards compatibility aliases during refactor
  static const Color primaryLight = primary;
  static const Color primaryDark = Color(0xFF4CAF50);
  static const Color secondaryLight = secondary;
  static const Color secondaryDark = Color(0xFFFFD54F);
}
