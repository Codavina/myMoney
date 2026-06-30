import 'package:flutter/material.dart';


class FinalBalanceCard extends StatelessWidget {
  const FinalBalanceCard({
    super.key,
    required this.amount,
  });

  final String amount;

  @override
  Widget build(BuildContext context) {
    final text =
        Theme.of(context).textTheme;

    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              'Solde:',
              style:
              text.titleMedium,
            ),
            const Spacer(),
            Text(
              amount,
              style:
              text.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}