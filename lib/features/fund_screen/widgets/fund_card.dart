import 'package:flutter/material.dart';
import 'package:my_money/core/extensions/string_extensions.dart';
import 'package:my_money/core/models/fund_model.dart';
import '../../../core/utils/app_formatter.dart';

class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.onPressed,
    required this.currencyCode,
        required this.flag,
    required this.info,
  });

  final FundModel fund;
  final VoidCallback? onPressed;
  final String currencyCode;
  final String flag;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 130),
            width: double.infinity,

            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(48),
              ),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
              color: const Color(0xffFFFFFF),

            ),),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration:  const BoxDecoration(
                color: Color(0xFF14B8A6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 8.0),
            child: Row(

              children: [

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fund.title.toSimpleTitleCase(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${AppFormatter.money.format(fund.balance)} $info',
                        style: Theme.of(context).textTheme.titleLarge!,
                      ),
                    ],
                  ),
                ),

                CircleAvatar(
                  radius: 22,
                  backgroundColor: const  Color(0xFFE0F2FE),
                  child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 26,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
