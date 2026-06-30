import 'package:flutter/material.dart';
import '../constants/app_colors.dart';


ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  brightness: Brightness.dark,

  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),

  scaffoldBackgroundColor:
  AppColors.darkBackground,

  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor:
    AppColors.darkBackground,
    foregroundColor:
    AppColors.darkText,
    surfaceTintColor:
    Colors.transparent,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    color: AppColors.darkSurface,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius:
      BorderRadius.circular(20),
      side: const BorderSide(
        color: AppColors.darkBorder,
      ),
    ),
  ),

  floatingActionButtonTheme:
  const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),

  navigationBarTheme:
  NavigationBarThemeData(
    indicatorColor:
    AppColors.primary.withValues(alpha: .25),
    labelTextStyle:
    WidgetStateProperty.all(
      const TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  elevatedButtonTheme:
  ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      minimumSize:
      const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(16),
      ),
    ),
  ),

  inputDecorationTheme:
  InputDecorationTheme(
    filled: true,
    fillColor:
    AppColors.darkSurface,
    contentPadding:
    const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    border: OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: AppColors.darkBorder,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: AppColors.darkBorder,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: 2,
      ),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius:
      BorderRadius.circular(16),
    ),
  ),

  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius:
      BorderRadius.circular(24),
    ),
  ),

  listTileTheme:
  const ListTileThemeData(
    contentPadding:
    EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    iconColor:
    AppColors.primary,
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
      fontWeight: FontWeight.w600,
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
  ),
);