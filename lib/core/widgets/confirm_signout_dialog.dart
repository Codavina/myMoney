import 'package:flutter/material.dart';
import 'package:my_money/core/widgets/custom_dialog_title.dart';
import 'package:my_money/core/widgets/dialog_title_decoration.dart';

import '../theme/app_color_extension.dart';


Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Yes',
  String cancelText = 'Cancel',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: DialogTitleDecoration(
          dialogTitle: DialogTitle(title: title),
          color: context.appColors.error,
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(cancelText),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.appColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
