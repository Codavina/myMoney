import 'package:easy_localization/easy_localization.dart';
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
         PopupMenuItem(
          value: MenuAction.edit,
          child: Row(
            children: [
              const Icon(Icons.edit),
              const SizedBox(width: 4),
              Text('edit'.tr()),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuAction.delete,
          child: Row(
            children: [
              const Icon(Icons.delete, color: Colors.red),
              const SizedBox(width: 4),
              Text('delete'.tr()),
            ],
          ),
        ),
      ],
    );
  }
}