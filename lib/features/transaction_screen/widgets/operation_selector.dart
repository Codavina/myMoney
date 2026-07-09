import 'package:flutter/material.dart';

import '../../../core/models/transaction_model.dart';

class OperationSelector extends StatelessWidget {
  const OperationSelector({
    super.key, required this.selectedType, required this.onChanged,

  });

  final TransactionType selectedType;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Withdraw'),
          selected: selectedType == TransactionType.withdrawal,
          onSelected: (_) => onChanged(TransactionType.withdrawal),
        ),

        const SizedBox(width: 12),

        ChoiceChip(
          label: const Text('Deposit'),
          selected: selectedType == TransactionType.deposit,
          onSelected: (_) => onChanged(TransactionType.deposit),
        ),
      ],
    );
  }
}