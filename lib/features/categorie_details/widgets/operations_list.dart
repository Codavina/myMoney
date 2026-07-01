import 'package:flutter/material.dart';

import '../data/operation_model.dart';
import 'operation_row.dart';

class OperationsList extends StatelessWidget {
  const OperationsList({
    super.key,
    required this.operations,
  });

  final List<OperationModel> operations;

  @override
  Widget build(BuildContext context) {

    return ListView.separated(

      itemCount: operations.length,

      separatorBuilder: (ctx, i) =>
      const Divider(height: 1),

      itemBuilder: (_, index) {

        return OperationRow(
          operation: operations[index],
        );

      },
    );
  }
}