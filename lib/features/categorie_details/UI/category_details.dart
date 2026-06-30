import 'package:flutter/material.dart';
import 'package:my_money/features/categorie_details/widgets/final_balance_card.dart';
import '../../add_transaction_dialog/UI/add_transaction_dialog_view.dart';
import '../data/operation_model.dart';
import '../widgets/table_content.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({
    super.key,
    required this.categoryTitle,
  });

  final String categoryTitle;

  @override
  State<CategoryDetails> createState() =>
      _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {


  final List<OperationModel> operations = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              const FinalBalanceCard(
                amount: '6.700.000,00 DA',
              ),

              const SizedBox(height: 16),

              Expanded(
                child: TableContent(
                  operations: operations,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(

        onPressed: () async {

          final operation =
          await showDialog<OperationModel>(
            context: context,
            builder: (_) =>
            const AddTransactionDialogView(),
          );

          if (operation != null) {
            setState(() {
              operations.add(operation);
            });
          }
        },

        label: const Text('Transaction'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}


