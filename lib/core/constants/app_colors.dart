import 'package:flutter/material.dart';


class AppColors {

  /// LIGHT
  static const light = AppColorPalette(
    primary: Color(0xFF0088CC),
    secondary: Color(0xFF64748B),

    success: Color(0xFF009688),
    error: Color(0xFFD32F2F),
    warning: Color(0xFFF9A825),
    info: Color(0xFF1565C0),

    background: Color(0xFFF1F5F9),
    surface: Colors.white,
    border: Color(0xFFE0E0E0),
    text: Color(0xFF1E293B),
    subtitle: Color(0xFF64748B),

    tableBackground: Colors.white54,
    fundCardBackground: Color(0xFFFAFBFC),
    fundCardBorder: Color(0xFFE5E7EB),

    currencySubtitleBackground: Color(0x140088CC),

    fundAccent: Color(0xFF14B8A6),

    avatarBackground: Color(0xFFE0F2FE),
    avatarIcon: Color(0xFF0284C7),

    onPrimary: Colors.white,

    deposit:  Color(0xffC8E6C9),
    withdraw: Color(0xffFFCDD2),
    unSelected: Color(0xffF5F5F5),

    balanceCardBackground: Color(0xFFEAF5FC),
    balanceCardBorder: Color(0xffBDBDBD),
    balanceCardLabel: Color(0xff616161),

    deleteDialogBackground: Color(0xFFF8FAFC),
    deleteDialogContent: Color(0xFF1E293B),
  );

  /// DARK
  static const dark = AppColorPalette(
    primary: Color(0xFF38BDF8),
    secondary: Color(0xFF94A3B8),

    success: Color(0xFF009688),
    error: Color(0xFFF87171),
    warning: Color(0xFFFACC15),
    info: Color(0xFF60A5FA),

    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    border: Color(0xFF2C2C2C),
    text: Color(0xFFF8FAFC),
    subtitle: Color(0xFF94A3B8),

    tableBackground: Color(0x331E293B),
    fundCardBackground: Color(0xFF1E293B),
    fundCardBorder: Color(0xFF334155),

    currencySubtitleBackground: Color(0x1A38BDF8),

    fundAccent: Color(0xFF2DD4BF),

    avatarBackground: Color(0xFF0C4A6E),
    avatarIcon: Color(0xFF38BDF8),

    onPrimary: Colors.white,

    unSelected: Color(0xFF374151),
    withdraw: Color(0xFF7F1D1D),
    deposit: Color(0xFF2E7D32),

    balanceCardBackground: Color(0xFF163447),
    balanceCardBorder: Color(0xFF6B7280),
    balanceCardLabel: Color(0xFFD1D5DB),

    deleteDialogBackground: Color(0xFF1E293B),
    deleteDialogContent: Color(0xFFF8FAFC),


  );
}


class AppColorPalette {
  final Color primary;
  final Color secondary;

  final Color success;
  final Color error;
  final Color warning;
  final Color info;

  final Color background;
  final Color surface;
  final Color border;
  final Color text;
  final Color subtitle;

  final Color tableBackground;

  final Color fundCardBackground;
  final Color fundCardBorder;

  final Color currencySubtitleBackground;

  final Color fundAccent;

  final Color avatarBackground;
  final Color avatarIcon;

  final Color onPrimary;

  final Color unSelected;
  final Color withdraw;
  final Color deposit;

  final Color balanceCardBackground;
  final Color balanceCardBorder;
  final Color balanceCardLabel;

  final Color deleteDialogBackground;
  final Color deleteDialogContent;


  const AppColorPalette({
    required this.primary,
    required this.secondary,

    required this.success,
    required this.error,
    required this.warning,
    required this.info,

    required this.background,
    required this.surface,
    required this.border,
    required this.text,
    required this.subtitle,

    required this.tableBackground,

    required this.fundCardBackground,
    required this.fundCardBorder,

    required this.currencySubtitleBackground,

    required this.fundAccent,

    required this.avatarBackground,
    required this.avatarIcon,

    required this.onPrimary,
    required this.unSelected,
    required this.withdraw,
    required this.deposit,
    required this.balanceCardBackground,
    required this.balanceCardBorder,
    required this.balanceCardLabel,
    required this.deleteDialogContent,
    required this.deleteDialogBackground,


  });
}