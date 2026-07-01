import 'package:flutter/services.dart';

class AmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;

    final separatorCount =
        ','.allMatches(text).length +
            '.'.allMatches(text).length;

    if (separatorCount > 1) {
      return oldValue;
    }

    final parts = text.split(RegExp(r'[,.]'));

    if (parts.length == 2 &&
        parts[1].length > 2) {
      return oldValue;
    }

    return newValue;
  }

  static double parseAmount(String text) {
    return double.parse(
      text.trim().replaceAll(',', '.'),
    );
  }
}