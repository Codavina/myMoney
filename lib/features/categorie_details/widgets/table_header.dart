import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Date', style: text.titleSmall)),
          Expanded(
            flex: 4,
            child: Text('Opération', style: text.titleSmall),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('Montant', style: text.titleSmall),
            ),
          ),
        ],
      ),
    );
  }
}