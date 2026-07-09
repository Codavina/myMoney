import 'package:flutter/material.dart';
import 'package:my_money/core/utils/app_formatter.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.balance});

  final double balance;


  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      color: const Color(0xFFF4C430).withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text('Solde:', style: text.titleMedium),
            const Spacer(),
            Text(AppFormatter.money.format(balance), style: text.titleLarge),
          ],
        ),
      ),
    );
  }
}
