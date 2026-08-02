import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_money/core/theme/app_color_extension.dart';
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
          label: Text('withdraw'.tr()),
          selected: selectedType == TransactionType.withdrawal,
          onSelected: (_) => onChanged(TransactionType.withdrawal),
          color: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return context.appColors.withdraw;
            }
            return context.appColors.unSelected;
          }),

        ),

        const SizedBox(width: 12),

        ChoiceChip(
          label:  Text('deposit'.tr()),
          selected: selectedType == TransactionType.deposit,
          onSelected: (_) => onChanged(TransactionType.deposit),
          color: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return context.appColors.deposit;
            }
            return context.appColors.unSelected;
          }),
        ),
      ],
    );
  }
}