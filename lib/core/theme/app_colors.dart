import 'package:flutter/material.dart';

/// Semantic color tokens for the app design system
/// This provides a centralized and consistent color palette
class AppColors {
  const AppColors._();

  // ============================================
  // Brand Colors
  // ============================================

  /// Primary brand color - Pokedex red
  static const Color primaryLight = Color(0xFFDC0A2D);
  static const Color primaryDark = Color(0xFFFF6B6B);

  /// Secondary brand colors
  static const Color secondaryLight = Color(0xFF3B4CCA);
  static const Color secondaryDark = Color(0xFF6B7AFF);

  // ============================================
  // Background Colors
  // ============================================

  /// Main background colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1A1A2E);

  /// Surface colors for cards and elevated surfaces
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF16213E);

  /// Card colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1F2B47);

  // ============================================
  // Text Colors
  // ============================================

  /// Primary text colors
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);

  /// Secondary text colors
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  /// Hint text colors
  static const Color textHintLight = Color(0xFF9CA3AF);
  static const Color textHintDark = Color(0xFF6B7280);

  // ============================================
  // Semantic Colors
  // ============================================

  /// Success colors
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successDark = Color(0xFF166534);

  /// Warning colors
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFB45309);

  /// Error colors
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFB91C1C);

  /// Info colors
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF1D4ED8);

  // ============================================
  // Gender Colors
  // ============================================

  static const Color male = Color(0xFF60A5FA);
  static const Color female = Color(0xFFF472B6);
  static const Color genderless = Color(0xFF9CA3AF);

  // ============================================
  // Stat Rating Colors
  // ============================================

  static const Color statLegendary = Color(0xFF8B5CF6);
  static const Color statExcellent = Color(0xFF22C55E);
  static const Color statGood = Color(0xFF3B82F6);
  static const Color statAverage = Color(0xFFF59E0B);
  static const Color statBelowAverage = Color(0xFFEF4444);

  // ============================================
  // Neutral Colors
  // ============================================

  static const Color white = Colors.white;
  static const Color black = Colors.black;

  /// Grey scale
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ============================================
  // Overlay & Opacity Colors
  // ============================================

  static Color overlay(double opacity) => Colors.black.withOpacity(opacity);
  static Color overlayLight(double opacity) =>
      Colors.white.withOpacity(opacity);

  // ============================================
  // Border Colors
  // ============================================

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // ============================================
  // Shadow Colors
  // ============================================

  static Color shadowLight = Colors.black.withOpacity(0.08);
  static Color shadowDark = Colors.black.withOpacity(0.24);

  // ============================================
  // Focus & Selection Colors
  // ============================================

  static Color focusBorderLight = primaryLight.withOpacity(0.5);
  static Color focusBorderDark = primaryDark.withOpacity(0.5);

  // ============================================
  // Helper Methods
  // ============================================

  /// Get primary color based on brightness
  static Color primary(Brightness brightness) {
    return brightness == Brightness.light ? primaryLight : primaryDark;
  }

  /// Get background color based on brightness
  static Color background(Brightness brightness) {
    return brightness == Brightness.light ? backgroundLight : backgroundDark;
  }

  /// Get surface color based on brightness
  static Color surface(Brightness brightness) {
    return brightness == Brightness.light ? surfaceLight : surfaceDark;
  }

  /// Get card color based on brightness
  static Color card(Brightness brightness) {
    return brightness == Brightness.light ? cardLight : cardDark;
  }

  /// Get text primary color based on brightness
  static Color textPrimary(Brightness brightness) {
    return brightness == Brightness.light ? textPrimaryLight : textPrimaryDark;
  }

  /// Get text secondary color based on brightness
  static Color textSecondary(Brightness brightness) {
    return brightness == Brightness.light
        ? textSecondaryLight
        : textSecondaryDark;
  }

  /// Get border color based on brightness
  static Color border(Brightness brightness) {
    return brightness == Brightness.light ? borderLight : borderDark;
  }

  /// Get stat color based on stat value
  static Color getStatColor(int statValue) {
    if (statValue >= 150) return statLegendary;
    if (statValue >= 120) return statExcellent;
    if (statValue >= 90) return statGood;
    if (statValue >= 60) return statAverage;
    return statBelowAverage;
  }

  /// Get stat rating color based on total stats
  static Color getStatRatingColor(int total) {
    if (total >= 600) return statLegendary;
    if (total >= 500) return statExcellent;
    if (total >= 400) return statGood;
    if (total >= 300) return statAverage;
    return statBelowAverage;
  }
}

/// Extension for easy access to semantic colors from ThemeData
extension AppColorsExtension on ThemeData {
  /// Get semantic colors based on current theme brightness
  AppSemanticColors get semanticColors => AppSemanticColors(brightness);
}

/// Semantic color accessor based on brightness
class AppSemanticColors {
  final Brightness brightness;

  const AppSemanticColors(this.brightness);

  bool get isDark => brightness == Brightness.dark;

  Color get primary => isDark ? AppColors.primaryDark : AppColors.primaryLight;
  Color get secondary =>
      isDark ? AppColors.secondaryDark : AppColors.secondaryLight;
  Color get background =>
      isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  Color get surface => isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get card => isDark ? AppColors.cardDark : AppColors.cardLight;
  Color get textPrimary =>
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  Color get textSecondary =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  Color get textHint =>
      isDark ? AppColors.textHintDark : AppColors.textHintLight;
  Color get border => isDark ? AppColors.borderDark : AppColors.borderLight;
  Color get focusBorder =>
      isDark ? AppColors.focusBorderDark : AppColors.focusBorderLight;
}
