import 'package:flutter/material.dart';
import 'package:my_money/core/models/transaction_model.dart';
import 'package:my_money/core/utils/app_formatter.dart';
import 'package:my_money/core/utils/app_validator.dart';
import '../../../core/utils/amount_formatter.dart';
import 'operation_selector.dart';
import '../../../core/widgets/custom_text_form_field.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key, required this.fundId});

  final int fundId;

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  TransactionType _selectedType = TransactionType.deposit;
  DateTime _selectedDate = DateTime.now();

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
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );

    if (date == null) return;
    _selectedDate = date;
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
              //  const TransactionCategory(),
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
                readOnly: true,

                onTap: _pickDate,
              ),
              const SizedBox(height: 12),
              OperationSelector(

                selectedType: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
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
              final amount = AmountFormatter.parseAmount(
                _amountController.text,
              );

              final transaction = TransactionModel(
                amount: amount,
                description: _descriptionController.text,
                transactionType: _selectedType,
                fundId: widget.fundId,
                transactionDate: _selectedDate,
              );

              Navigator.pop(context, transaction);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
