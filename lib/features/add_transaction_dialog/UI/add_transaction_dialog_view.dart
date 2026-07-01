import 'package:flutter/material.dart';
import 'package:my_money/core/utils/app_formatter.dart';
import 'package:my_money/core/utils/app_validator.dart';
import '../../../core/utils/amount_formatter.dart';
import '../../categorie_details/data/operation_model.dart';
import '../widgets/operation_selector.dart';
import '../widgets/transaction_category.dart';
import '../widgets/custom_text_form_field.dart';

class AddTransactionDialogView extends StatefulWidget {
  const AddTransactionDialogView({super.key});

  @override
  State<AddTransactionDialogView> createState() =>
      _AddTransactionDialogViewState();
}

class _AddTransactionDialogViewState extends State<AddTransactionDialogView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  //DateTime? _selectedDate;
  List<bool> selected = [true, false];
  bool isDeposit = true;


  @override
  void initState() {
       super.initState();
    _dateController.text = AppFormatter.date.format(DateTime.now());
  }
  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );

    if (date == null) return;
    // _selectedDate = date;
    _dateController.text = AppFormatter.date.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Transaction'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const TransactionCategory(),
              const SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Amount',
                controller: _amountController,
                validator: AppValidators.amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [AmountFormatter()],
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: 'Description',
                controller: _descriptionController,
                validator: AppValidators.description,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: 'Date',
                controller: _dateController,
                keyboardType: TextInputType.datetime,

                onTap: _pickDate,
              ),
              const SizedBox(height: 12),
              OperationSelector(
                isDeposit: isDeposit,
                onChanged: (value) {
                  setState(() {
                    isDeposit = value;
                  });
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),

      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final amount =AmountFormatter.parseAmount(_amountController.text);
              final operation = OperationModel(
                amount: amount,
                description: _descriptionController.text,
                date: _dateController.text,
                isDeposit: isDeposit,
              );

              Navigator.pop(context, operation);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
