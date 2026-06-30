import 'package:flutter/material.dart';

import '../data/operation_model.dart';
import 'operations_table.dart';

class OperationsTableListView extends StatelessWidget {

  const OperationsTableListView({
    super.key,
    required this.operations,
  });

  final List<OperationModel> operations;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: ListView.builder(
        itemCount: operations.length,

        itemBuilder: (context, index) {

          return OperationsTable(
            operations: operations[index],
          );

        },
      ),
    );
  }
}
