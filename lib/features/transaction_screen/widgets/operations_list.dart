import 'package:flutter/material.dart';
import 'package:my_money/core/models/transaction_model.dart';

import 'operation_row.dart';


class OperationsList extends StatelessWidget {
  const OperationsList({
    super.key,
    required this.transactions,
  });

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {

    return ListView.separated(

      itemCount: transactions.length,

      separatorBuilder: (ctx, i) =>
      const Divider(height: 1),

      itemBuilder: (_, index) {

        return OperationRow(
          transaction: transactions[index],
        );

      },
    );
  }
}