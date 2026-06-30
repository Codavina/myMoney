import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    super.key,
    required this.amount,
    required this.lastUpdate,
  });

  final String amount;
  final String lastUpdate;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Total Général',
              style: text.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style:
              text.displayLarge?.copyWith(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Dernière mise à jour : $lastUpdate',
              style: text.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}