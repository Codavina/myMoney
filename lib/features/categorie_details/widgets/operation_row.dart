import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/operation_model.dart';

class OperationRow extends StatelessWidget {

  const OperationRow({
    super.key,
    required this.operation,
  });

  final OperationModel operation;

  @override
  Widget build(BuildContext context) {

    final text = Theme.of(context).textTheme;

    final formatter =
    NumberFormat('#,##0.00');

    final sign =
    operation.isDeposit ? '+' : '-';

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      child: Row(

        children: [

          Expanded(
            flex: 2,
            child: Text(operation.date),
          ),

          Expanded(
            flex: 5,
            child: Row(

              children: [

                Icon(
                  operation.isDeposit
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    operation.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              ],
            ),
          ),

          Expanded(
            flex: 3,
            child: Align(

              alignment:
              Alignment.centerRight,

              child: Text(

                '$sign${formatter.format(operation.amount)}',

                style: text.bodyMedium?.copyWith(

                  fontWeight: FontWeight.bold,

                  color: operation.isDeposit
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