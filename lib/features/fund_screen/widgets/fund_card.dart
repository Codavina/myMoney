import 'package:flutter/material.dart';
import 'package:my_money/core/extensions/string_extensions.dart';
import 'package:my_money/core/models/fund_model.dart';
import '../../../core/theme/app_color_extension.dart';
import '../../../core/utils/app_formatter.dart';
import '../../currency_screen/widgets/currency_flag.dart';

class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.onPressed,
    required this.flag,
    required this.info,
  });

  final FundModel fund;
  final VoidCallback? onPressed;
  final String flag;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 115),
            width: double.infinity,

            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: context.appColors.text.withValues(alpha: 0.03),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(48),
              ),
              border: Border.all(color: context.appColors.fundCardBorder, width: 1),
              color: context.appColors.fundCardBackground,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                color: context.appColors.fundAccent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          CurrencyFlag(flag: flag),
                          const SizedBox(width: 4),
                          Text(
                            fund.title.toSimpleTitleCase(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: context.appColors.text),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${AppFormatter.money.format(fund.balance)} $info',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: context.appColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),

                CircleAvatar(
                  radius: 22,
                  backgroundColor: context.appColors.avatarBackground,
                  child: IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 26,
                      color: context.appColors.avatarIcon,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
