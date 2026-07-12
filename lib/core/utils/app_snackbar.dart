import 'package:flutter/material.dart';


class AppSnackBar {
  const AppSnackBar._();

  static void success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        elevation: 8,
        duration: const Duration(seconds: 2),
     //   margin: const EdgeInsets.all(16),//use margin just with floating
        backgroundColor: Colors.teal,//green.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        elevation: 8,
        duration: const Duration(seconds: 3),
       // margin: const EdgeInsets.all(16),
        backgroundColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.error_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}