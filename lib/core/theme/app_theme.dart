import 'package:flutter/material.dart';

/// App theme configuration with Pokemon-inspired colors
class AppTheme {
  const AppTheme._();

  // Primary colors inspired by Pokedex red
  static const Color _primaryLight = Color(0xFFDC0A2D);
  static const Color _primaryDark = Color(0xFFFF6B6B);

  // Background colors
  static const Color _backgroundLight = Color(0xFFF5F5F5);
  static const Color _backgroundDark = Color(0xFF1A1A2E);

  // Surface colors
  static const Color _surfaceLight = Colors.white;
  static const Color _surfaceDark = Color(0xFF16213E);

  // Card colors
  static const Color _cardLight = Colors.white;
  static const Color _cardDark = Color(0xFF1F2B47);

  /// Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryLight,
        brightness: Brightness.light,
        primary: _primaryLight,
        surface: _surfaceLight,
      ),
      scaffoldBackgroundColor: _backgroundLight,
      cardTheme: CardThemeData(
        color: _cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: _primaryLight,
        unselectedLabelColor: Colors.grey,
        indicatorColor: _primaryLight,
      ),
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryDark,
        brightness: Brightness.dark,
        primary: _primaryDark,
        surface: _surfaceDark,
      ),
      scaffoldBackgroundColor: _backgroundDark,
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: _primaryDark,
        unselectedLabelColor: Colors.grey,
        indicatorColor: _primaryDark,
      ),
    );
  }
}
