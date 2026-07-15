import 'package:flutter/material.dart';

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
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}