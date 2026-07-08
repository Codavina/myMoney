import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  // static const primary = Color(0xFF2E7D32);
  static const primary = Color(0xFF4F46E5);
  static const secondary = Color(0xFF66BB6A);

  // States
  static const success = Color(0xFF2E7D32);
  static const error = Color(0xFFD32F2F);
  static const warning = Color(0xFFF9A825);
  static const info = Color(0xFF1565C0);

  // Light
  //static const lightBackground = Color(0xFFF5F7FA);
  // static const lightText = Color(0xFF1C1C1E);
  // static const lightSubtitle = Color(0xFF757575);
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Colors.white;
  static const lightBorder = Color(0xFFE0E0E0);
  static const lightText = Color(0xFF1E293B);
  static const lightSubtitle = Color(0xFF64748B);

  // Dark
  // static const darkBackground = Color(0xFF121212);
  // static const darkSurface = Color(0xFF1E1E1E);
  // static const darkBorder = Color(0xFF2C2C2C);
  // static const darkText = Colors.white;
  // static const darkSubtitle = Color(0xFFB0B0B0);

  static const darkBackground = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkBorder = Color(0xFF2C2C2C);
  static const darkText = Color(0xFFF8FAFC);
  static const darkSubtitle = Color(0xFF94A3B8);

  static  List<Color> fundCardColor = [
    const Color(0xFFF4C430).withValues(alpha: 0.2), // Sunflower
    const Color(0xFF00BFFF).withValues(alpha: 0.2), // Sky Blue
    const Color(0xFFFF6F61).withValues(alpha: 0.2), // Coral
    const Color(0xFF4169E1).withValues(alpha: 0.2), // Royal Blue
    const Color(0xFF008080).withValues(alpha: 0.2),// Teal
    const Color(0xFF5a2f26).withValues(alpha: 0.15),//Dark Brown
    const Color(0xFF9B59B6).withValues(alpha: 0.2), // Purple
  ];

  static  List<Color> fundTextColor = [
    const Color(0xFFF4C430), // Sunflower
    const Color(0xFF00BFFF), // Sky Blue
    const Color(0xFFFF6F61), // Coral
    const Color(0xFF4169E1), // Royal Blue
    const Color(0xFF008080),// Teal
    const Color(0xFF5a2f26),//Dark Brown
    const Color(0xFF9B59B6), // Purple
  ];
}
