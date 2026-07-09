import 'package:flutter/material.dart';
import 'package:my_money/core/models/transaction_model.dart';
import 'package:my_money/features/transaction_screen/widgets/table_header.dart';
import 'empty_operations.dart';
import 'operations_list.dart';

class OperationsTable extends StatelessWidget {
  const OperationsTable({
    super.key,
    required this.transactions,
  });

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: .8,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [

          const TableHeader(),

          const Divider(height: 1),

          Expanded(
            child: transactions.isEmpty
                ? const EmptyOperations()
                : OperationsList(
              transactions: transactions,
            ),
          ),

        ],
      ),
    );
  }
}




