import 'package:flutter/material.dart';
import 'package:my_money/core/utils/app_validator.dart';
import '../../funds_details_page/UI/add_transaction_dialog/widgets/custom_text_form_field.dart';
import '../../funds_details_page/data/category_model.dart';

class AddFundDialog extends StatefulWidget {
  const AddFundDialog({super.key});

  @override
  State<AddFundDialog> createState() => _AddFundDialogState();
}

class _AddFundDialogState extends State<AddFundDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _titleController = TextEditingController();


  String selectedCurrency = 'DZD';

  CategoryModel? category;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              CustomTextFormField(labelText: 'title', controller: _titleController
              ,validator: AppValidators.title,),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCurrency,
                decoration: const InputDecoration(labelText: 'Currency'),
                items: const [
                  DropdownMenuItem(value: 'DZD', child: Text('DZD')),
                  DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                  DropdownMenuItem(value: 'USD', child: Text('USD')),
                  DropdownMenuItem(value: 'TND', child: Text('TND')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value!;
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
              category = CategoryModel(
                title: _titleController.text.trim(),
                currency: selectedCurrency,
              );

              Navigator.pop(context, category);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
