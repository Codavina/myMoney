import 'package:flutter/material.dart';

import 'custom_dialog_title.dart';
import 'dialog_title_decoration.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.isArchived = false,
    required this.textToAction,
    required this.color,
  });

  final String title;
  final String message;
  final String textToAction;
  final bool isArchived;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      title: DialogTitleDecoration(
        color: isArchived ? Colors.grey.shade600 : Colors.red.shade400,
        dialogTitle: DialogTitle(title: title),
      ),
      content: Text.rich(
        TextSpan(
          text: '$message (',
          children: [
            TextSpan(
              text: textToAction,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            const TextSpan(text: ') ?'),
          ],
        ),
      ),
      //Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: isArchived
                ? Colors.grey.shade600
                : Colors.red.shade400,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(isArchived ? 'Archive' : 'Delete'),
        ),
      ],
    );
  }
}
