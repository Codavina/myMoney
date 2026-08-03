import 'package:flutter/material.dart';
import '../theme/app_color_extension.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    debugPrint("Custom Floating Action Button Build");
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: context.appColors.primary,
      foregroundColor: context.appColors.surface,
      icon: const Icon(Icons.add),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}