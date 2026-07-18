import 'package:flutter/material.dart';

enum MenuAction { edit, delete,}

class CurrencyPopUpMenu extends StatelessWidget {
  const CurrencyPopUpMenu({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<MenuAction> onSelected;


  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(

      onSelected: onSelected,
      itemBuilder: (context) => [
         const PopupMenuItem(
          value: MenuAction.edit,
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 4),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MenuAction.delete,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 4),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }
}