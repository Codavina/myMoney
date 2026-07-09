import 'package:flutter/material.dart';
import 'package:my_money/core/models/transaction_model.dart';
import 'package:my_money/core/utils/app_formatter.dart';



class OperationRow extends StatelessWidget {

  const OperationRow({
    super.key,
    required this.transaction,
  });

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {

    final text = Theme.of(context).textTheme;
    final sign = transaction.transactionType==TransactionType.deposit?'+' : '-';


    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),

      child: Row(

        children: [

          Expanded(
            flex: 2,
            child: Text(AppFormatter.date.format(transaction.transactionDate)),
          ),

          Expanded(
            flex: 4,
            child: Text(
              transaction.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),

          Expanded(
            flex: 3,
            child: Align(

              alignment:
              Alignment.centerRight,

              child: Text(

                '$sign ${AppFormatter.money.format(transaction.amount)}',

                style: text.bodyMedium?.copyWith(

                  fontWeight: FontWeight.w600,
                  fontSize: 12,

                  color: transaction.transactionType==TransactionType.deposit
                      ? Colors.green.shade700
                      : Colors.red.shade700,

                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}