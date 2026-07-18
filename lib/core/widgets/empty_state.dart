import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key, required this.image,
  });
  final String image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(image,
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.height * 0.35,
      ),
    );
  }
}