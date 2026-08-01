import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

extension AppColorsExtension on BuildContext {
  AppColorPalette get appColors {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
  }
}