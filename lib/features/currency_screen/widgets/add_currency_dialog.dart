import 'package:flutter/material.dart';
import 'package:my_money/core/models/currency_model.dart';
import 'package:my_money/core/widgets/custom_dialog_title.dart';
import 'package:my_money/core/widgets/dialog_title_decoration.dart';
import '../../../core/theme/app_color_extension.dart';
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
      title: DialogTitleDecoration(
        dialogTitle: DialogTitle(
          title: isEdit ? 'Edit Currency' : 'Add Currency',
        ),
        color: isEdit ? context.appColors.success : context.appColors.primary,
      ),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: isEdit ? context.appColors.success : context.appColors.primary,
          ),
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
          child: Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
