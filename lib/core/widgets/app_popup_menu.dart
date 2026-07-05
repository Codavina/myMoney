import 'package:flutter/material.dart';

class AppPopUpMenu extends StatelessWidget {
  const AppPopUpMenu({
    super.key,
    required this.onSelected,
  });

  final void Function(String)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 4),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red.shade700),
              const SizedBox(width: 4),
              const Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }
}