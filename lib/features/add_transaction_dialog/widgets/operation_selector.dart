import 'package:flutter/material.dart';

class OperationSelector extends StatelessWidget {
  const OperationSelector({
    super.key,
    required this.isDeposit,
    required this.onChanged,
  });

  final bool isDeposit;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Withdraw'),
          selected: !isDeposit,
          onSelected: (_) => onChanged(false),
        ),

        const SizedBox(width: 12),

        ChoiceChip(
          label: const Text('Deposit'),
          selected: isDeposit,
          onSelected: (_) => onChanged(true),
        ),
      ],
    );
  }
}