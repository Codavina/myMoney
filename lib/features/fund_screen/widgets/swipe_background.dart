import 'package:flutter/material.dart';
import 'package:my_money/core/theme/app_color_extension.dart';

class SwipeBackground extends StatelessWidget {
  const SwipeBackground({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    this.alignment,
  });

  final Color color;
  final IconData icon;
  final String text;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: context.appColors.surface),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(color: context.appColors.surface, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}