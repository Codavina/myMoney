import 'package:flutter/material.dart';
import 'package:my_money/core/models/fund_model.dart';
import '../../../core/utils/app_formatter.dart';

class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.onPressed,
    required this.currencyCode, required this.color
  });

  final FundModel fund;
  final void Function()? onPressed;
  final String currencyCode;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Card(
        color: color,
        child: ListTile(

          contentPadding: const EdgeInsets.all(8.0),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              fund.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${AppFormatter.money.format(fund.balance)} $currencyCode',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          trailing: IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward_ios, size: 36),
          ),
        ),
      ),
    );
  }
}
