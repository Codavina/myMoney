import 'package:flutter/material.dart';
import 'package:my_money/core/constants/app_colors.dart';
import 'package:my_money/core/models/currency_model.dart';

import '../../../core/utils/app_validator.dart';
import '../../../core/widgets/custom_text_form_field.dart';

class AddCurrencyDialog extends StatefulWidget {
  const AddCurrencyDialog({super.key, this.currency});

  final CurrencyModel? currency;

  @override
  State<AddCurrencyDialog> createState() => _AddCurrencyDialogState();
}

class _AddCurrencyDialogState extends State<AddCurrencyDialog> {
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool get isEdit => widget.currency != null;

  @override
  void initState() {
    super.initState();
    if (widget.currency != null) {
      _titleController.text = widget.currency!.currencyCode;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      title: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:isEdit?Colors.teal: AppColors.primary,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),

           
          ),
          child: Text(isEdit ?'Edit Currency': 'Add Currency',textAlign: TextAlign.center,style: const TextStyle(color: Colors.white),)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            CustomTextFormField(
              labelText: 'Currency Code',
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
          style: ElevatedButton.styleFrom(backgroundColor: isEdit?Colors.teal:AppColors.primary),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;

            // Hide the keyboard before closing the dialog.
            FocusScope.of(context).unfocus();

            Navigator.pop(
              context,
              CurrencyModel(
                currencyId: widget.currency?.currencyId,
                currencyCode: _titleController.text.trim(),
              ),
            );
          },
          child: Text(isEdit? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
