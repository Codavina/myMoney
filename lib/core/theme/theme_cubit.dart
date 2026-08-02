import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.light);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool(_themeKey) ?? false;

    emit(
      isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;

    final newMode =
    isDark ? ThemeMode.light : ThemeMode.dark;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _themeKey,
      newMode == ThemeMode.dark,
    );

    emit(newMode);
  }
}