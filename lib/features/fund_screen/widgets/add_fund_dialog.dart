import 'package:flutter/material.dart';
import 'package:my_money/core/utils/app_validator.dart';
import '../../../core/models/currency_model.dart';
import '../../../core/models/fund_model.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import 'currency_dropdown_field.dart';

class AddFundDialog extends StatefulWidget {
  const AddFundDialog({super.key, this.fund, required this.currencies});

  final FundModel? fund;
  final List<CurrencyModel> currencies;

  @override
  State<AddFundDialog> createState() => _AddFundDialogState();
}

class _AddFundDialogState extends State<AddFundDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  CurrencyModel? _selectedCurrency;

  bool get isEdit => widget.fund != null;

  @override
  void initState() {
    super.initState();
    if (widget.fund != null) {
      _titleController.text = widget.fund!.title;

      _selectedCurrency = widget.currencies.firstWhere(
        (e) => e.currencyId == widget.fund!.currencyId,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Save the new fund and return it to the caller.
  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCurrency == null) return;
    // Hide the keyboard before closing the dialog.
    FocusScope.of(context).unfocus();

    Navigator.pop(
      context,
      FundModel(
        fundId: widget.fund?.fundId,
        title: _titleController.text.trim(),
        currencyId: _selectedCurrency!.currencyId!,
        createdAt: widget.fund?.createdAt ?? DateTime.now(),
        //balance: widget.fund!.balance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Edit Fund' : 'Add Fund'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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
                onChanged: (value) {
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

        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xff0088cc),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _save,
          child: Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
