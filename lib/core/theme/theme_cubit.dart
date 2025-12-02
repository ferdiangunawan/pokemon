import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

/// Cubit for managing app theme (light/dark mode)
class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs)
    : super(const ThemeState(themeMode: ThemeMode.system));

  /// Load saved theme from preferences
  void loadTheme() {
    final themeIndex = _prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    emit(ThemeState(themeMode: ThemeMode.values[themeIndex]));
  }

  /// Set theme mode
  Future<void> setTheme(ThemeMode mode) async {
    await _prefs.setInt(_themeKey, mode.index);
    emit(ThemeState(themeMode: mode));
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newThemeMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await setTheme(newThemeMode);
  }

  /// Check if current theme is dark
  bool get isDarkMode => state.themeMode == ThemeMode.dark;
}
