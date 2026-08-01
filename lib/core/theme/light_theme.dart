import 'package:flutter/material.dart';
import '../constants/app_colors.dart';


ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  brightness: Brightness.light,

  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.light.primary,
    brightness: Brightness.light,
  ),

  scaffoldBackgroundColor: AppColors.light.background,

  appBarTheme: AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: AppColors.light.primary,
    foregroundColor: AppColors.light.surface,
    surfaceTintColor: Colors.transparent,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    color: AppColors.light.surface,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        color: AppColors.light.border,
      ),
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.light.primary,
    foregroundColor: AppColors.light.onPrimary,
  ),

  navigationBarTheme: NavigationBarThemeData(
    indicatorColor:
    AppColors.light.primary.withValues(alpha: 0.15),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.light.primary,
      foregroundColor: AppColors.light.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.light.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: AppColors.light.border,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: AppColors.light.border,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: AppColors.light.primary,
        width: 2,
      ),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  ),

  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    iconColor: AppColors.light.primary,
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
    ),

    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),

    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),

    labelLarge: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),

    displayMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  ),
);