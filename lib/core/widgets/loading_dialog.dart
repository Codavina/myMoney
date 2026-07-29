import 'package:flutter/material.dart';

class LoadingDialog {
  const LoadingDialog._();

  static Future<void> show(
      BuildContext context, {
        String message = 'Please wait...',
      }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(message),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}