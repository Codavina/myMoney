import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_colors.dart';

class CurrencyFlag extends StatelessWidget {
  const CurrencyFlag({
    super.key,
    required this.flag,
  });

  final String flag;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 22,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),

          child: SvgPicture.asset(
            flag,
            fit: BoxFit.contain,width: 20,height: 20,
          ),
        ),
      ),
    );
  }
}