import 'package:flutter/material.dart';
import 'package:my_money/core/models/currency_model.dart';

import '../../../core/utils/app_validator.dart';
import '../../funds_details_page/UI/add_transaction_dialog/widgets/custom_text_form_field.dart';

class AddCurrencyDialog extends StatefulWidget {
  const AddCurrencyDialog({super.key});

  @override
  State<AddCurrencyDialog> createState() => _AddCurrencyDialogState();
}

class _AddCurrencyDialogState extends State<AddCurrencyDialog> {
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Add Currency'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            CustomTextFormField(
              labelText: 'title',
              controller: _titleController,
              validator: AppValidators.currencyCode,
            ),

            const SizedBox(height: 12),
          ],
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
            if (!_formKey.currentState!.validate()) return;

            // Hide the keyboard before closing the dialog.
            FocusScope.of(context).unfocus();

            Navigator.pop(
              context,
              CurrencyModel(
                currencyCode: _titleController.text.trim(),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
