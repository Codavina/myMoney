import 'package:flutter/material.dart';

class TransactionCategory extends StatefulWidget {
  const TransactionCategory({super.key});

  @override
  State<TransactionCategory> createState() => _TransactionCategoryState();
}

class _TransactionCategoryState extends State<TransactionCategory> {
  String selectedValue = 'A';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedValue,
      borderRadius: BorderRadius.circular(8),
      isExpanded: true,
      elevation: 0,
      items: const [
        DropdownMenuItem(value: 'A', child: Text('Category A')),
        DropdownMenuItem(value: 'B', child: Text('Category B')),
        DropdownMenuItem(value: 'C', child: Text('Category C')),
        DropdownMenuItem(value: 'D', child: Text('Category D')),
      ],
      onChanged: (value) {
        selectedValue = value!;
        setState(() {});
      },
    );
  }
}