import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.image,
    this.scrollable = false,
  });

  final String image;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final child = Center(
      child: Image.asset(
        image,
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.height * 0.35,
      ),
    );

    if (!scrollable) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: child,
          ),
        );
      },
    );
  }
}