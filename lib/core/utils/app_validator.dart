class AppValidators {
  AppValidators._();

  /// Description
  static String? description(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter a description.';
    }

    if (text.length < 3) {
      return 'Description must contain at least 3 characters.';
    }

    if (text.length > 100) {
      return 'Description cannot exceed 100 characters.';
    }

    return null;
  }

  ///title
  static String? title(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter a title.';
    }

    if (text.length < 3) {
      return 'Title must contain at least 3 characters.';
    }

    if (text.length > 50) {
      return 'Title cannot exceed 50 characters.';
    }

    return null;
  }

  ///Currency code
  static String? currencyCode(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter a currency Code (ex: (DZD).';
    }

    if (text.length < 3) {
      return 'At least 3 to 10 characters.';
    }

    if (text.length > 10) {
      return 'Code cannot exceed 10 characters.';
    }

    return null;
  }
  /// Amount
  static String? amount(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter an amount.';
    }

    final amount = double.tryParse(
      text.replaceAll(',', '.'),
    );

    if (amount == null) {
      return 'Please enter a valid amount.';
    }

    if (amount <= 0) {
      return 'Amount must be greater than zero.';
    }

    return null;
  }

  /// Date
  static String? date(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please select a date.';
    }

    return null;
  }
}