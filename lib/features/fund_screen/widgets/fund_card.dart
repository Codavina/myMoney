import 'package:flutter/material.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:svg_flutter/svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_formatter.dart';


class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.onPressed,
    required this.currencyCode,
    required this.backgroundColor, required this.flag,

  });

  final FundModel fund;
  final VoidCallback? onPressed;
  final String currencyCode;
  final Color backgroundColor;
  final String flag;


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Card(
        color: backgroundColor,
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
                '${AppFormatter.money.format(fund.balance)} ${currencyCode.toUpperCase()}',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),

          ),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),

                child: SvgPicture.asset(flag, fit: BoxFit.contain),
              ),
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
