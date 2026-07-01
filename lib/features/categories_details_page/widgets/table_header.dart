import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {

  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {

    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [

          Expanded(
            flex: 2,
            child: Text(
              "Date",
              style: text.labelLarge,
            ),
          ),

          Expanded(
            flex: 5,
            child: Text(
              "Description",
              style: text.labelLarge,
            ),
          ),

          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Amount",
                style: text.labelLarge,
              ),
            ),
          ),

        ],
      ),
    );
  }
}