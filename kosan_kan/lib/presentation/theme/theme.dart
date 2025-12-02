import 'package:flutter/material.dart';

class AppTheme {
  // Gen-Z friendly palette
  // Primary: vivid violet, Accent: mint, Accent2: coral
  static const Color _primary = Color(0xFF6C5CE7); // violet
  static const Color _onPrimary = Colors.white;
  static const Color _accent = Color(0xFF00B894); // mint
  static const Color _accent2 = Color(0xFFFF7675); // coral
  static const Color _background = Color(0xFFF7F6FF); // soft off-white
  static const Color _surface = Colors.white;
  static const Color _onSurface = Colors.black87;

  static ThemeData lightTheme() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _primary,
      onPrimary: _onPrimary,
      secondary: _accent,
      onSecondary: Colors.white,
      error: Colors.red.shade700,
      onError: Colors.white,
      background: _background,
      onBackground: _onSurface,
      surface: _surface,
      onSurface: _onSurface,
      tertiary: _accent2,
      onTertiary: Colors.white,
    );

    return ThemeData.from(
      colorScheme: colorScheme,
      textTheme: Typography.material2018().black,
    ).copyWith(
      useMaterial3: false,
      appBarTheme: AppBarTheme(
        backgroundColor: _surface,
        foregroundColor: _onSurface,
        elevation: 0,
        iconTheme: const IconThemeData(color: _primary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: _onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      cardColor: _surface,
      scaffoldBackgroundColor: _background,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(_primary),
      ),
      chipTheme: ChipThemeData.fromDefaults(
        secondaryColor: _accent,
        labelStyle: const TextStyle(color: Colors.white),
        brightness: Brightness.light,
      ),
    );
  }
}
