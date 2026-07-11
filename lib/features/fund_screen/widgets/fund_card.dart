import 'package:flutter/material.dart';
import 'package:my_money/core/constants/app_assets.dart';
import 'package:my_money/core/extensions/string_extensions.dart';
import 'package:my_money/core/models/fund_model.dart';
import '../../../core/utils/app_formatter.dart';

class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.onPressed,
    required this.currencyCode,
    required this.backgroundColor,
    required this.flag,
  });

  final FundModel fund;
  final VoidCallback? onPressed;
  final String currencyCode;
  final Color backgroundColor;
  final String flag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.17,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
            topRight: Radius.circular(48),
          ),
          color: backgroundColor,

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
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 1),
                    Text(
                      fund.title.toSimpleTitleCase(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Flexible(
                      child: Container(
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
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                color: backgroundColor.withValues(alpha: 1),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const Spacer(),
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
