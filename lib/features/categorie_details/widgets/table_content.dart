import 'package:flutter/material.dart';
import '../data/operation_model.dart';

class TableContent extends StatelessWidget {

  final List<OperationModel> operations;

  const TableContent({
    super.key,
    required this.operations,
  });

  @override
  Widget build(BuildContext context) {

    final text = Theme.of(context).textTheme;

    return ListView.separated(
      itemCount: operations.length,
      separatorBuilder: (context, i) => const Divider(height: 1),
      itemBuilder: (context, index) {

        final operation = operations[index];

        return SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [

                Expanded(
                  flex: 3,
                  child: Text(operation.date),
                ),

                Expanded(
                  flex: 4,
                  child: Text(operation.description),
                ),

                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      operation.amount,
                      style: text.bodyMedium?.copyWith(
                        color: operation.isDeposit
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}