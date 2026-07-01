import 'package:flutter/material.dart';
import 'package:my_money/features/categorie_details/widgets/table_header.dart';
import '../data/operation_model.dart';
import 'empty_operations.dart';
import 'operations_list.dart';

class OperationsTable extends StatelessWidget {
  const OperationsTable({
    super.key,
    required this.operations,
  });

  final List<OperationModel> operations;

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
            child: operations.isEmpty
                ? const EmptyOperations()
                : OperationsList(
              operations: operations,
            ),
          ),

        ],
      ),
    );
  }
}




