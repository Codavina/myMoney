import 'package:flutter/material.dart';
import 'package:my_money/features/categorie_details/widgets/table_header.dart';
import '../data/operation_model.dart';

class OperationsTable extends StatelessWidget {
  const OperationsTable({super.key, required this.operations});

  final OperationModel operations;

  @override
  Widget build(BuildContext context) {


    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      child: const Column(
        children: [
          TableHeader(),

          Divider(height: 1),

       //   TableContent(operations: operations),
        ],
      ),
    );
  }
}




