import 'package:flutter/material.dart';
import 'package:my_money/core/utils/app_validator.dart';
import '../../../core/models/currency_model.dart';
import '../../../core/models/fund_model.dart';
import '../../funds_details_page/UI/add_transaction_dialog/widgets/custom_text_form_field.dart';
import 'currency_dropdown_field.dart';

class AddFundDialog extends StatefulWidget {
  const AddFundDialog({super.key});

  @override
  State<AddFundDialog> createState() => _AddFundDialogState();
}

class _AddFundDialogState extends State<AddFundDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  CurrencyModel? _selectedCurrency;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Save the new fund and return it to the caller.
  void _save() {
    if (!_formKey.currentState!.validate()) return;

    // Hide the keyboard before closing the dialog.
    FocusScope.of(context).unfocus();

    Navigator.pop(
      context,
      FundModel(
        title: _titleController.text.trim(),
        currencyId: _selectedCurrency!.currencyId!,
        createdAt: DateTime.now(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Fund'),

      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                labelText: 'Fund Name',
                controller: _titleController,
                validator: AppValidators.title,
              ),

              const SizedBox(height: 16),

              CurrencyDropdownField(
                selectedCurrency: _selectedCurrency,
                onChanged: (value){
                  setState(() {
                    _selectedCurrency = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),

        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}


