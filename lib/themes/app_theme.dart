import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF256D85);
  static const Color secondary = Color(0xFF4C9BB3);
  static const Color background = Color(0xFFF6F9FB);
  static const Color surface = Colors.white;
  static const Color accent = Color(0xFFFFD54F);
  // Modern fixed palette for dashboard menu (pastel, harmonized)
  static const List<Color> menuColors = [
    Color(0xFFB3DBE0), // soft teal
    Color(0xFFD6E6F2), // soft blue
    Color(0xFFFCE7C6), // soft amber
    Color(0xFFF9D6E0), // soft pink
    Color(0xFFE7E5F9), // soft purple
  ];
}

class AppTheme {
  static ThemeData themeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      useMaterial3: true,
    );
  }
}
