import 'package:flutter/material.dart';
import 'package:my_money/core/constants/app_assets.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:svg_flutter/svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_formatter.dart';
import '../../currency_screen/currency_info.dart';

class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.onPressed,
    required this.currencyCode,
    required this.backgroundColor,
    required this.flag,
    required this.gradian1,
    required this.gradian2,
  });

  final FundModel fund;
  final VoidCallback? onPressed;
  final String currencyCode;
  final Color backgroundColor;
  final Color gradian1;
  final Color gradian2;
  final String flag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.18,

        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
            topRight: Radius.circular(48),
          ),
          // color: backgroundColor,
          gradient: LinearGradient(
            colors: [gradian1, gradian2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          image: const DecorationImage(
            image: AssetImage(AppAssets.bgMoney),
            repeat: ImageRepeat.repeat,
            fit: BoxFit.fitHeight,
            opacity: 0.015,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 8),
                  Text(
                    fund.title.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${AppFormatter.money.format(fund.balance)} ${currencyCode.toUpperCase()}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: backgroundColor.withValues(alpha: 1),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 26,
                        color: backgroundColor.withValues(alpha: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
