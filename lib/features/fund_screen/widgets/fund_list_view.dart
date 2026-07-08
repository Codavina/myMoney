import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/features/fund_screen/widgets/fund_card.dart';
import 'package:my_money/features/funds_details_page/UI/fund_details_page.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/cubit/currency/currency_cubit.dart';
import '../../../core/cubit/currency/currency_state.dart';
import '../../../core/models/currency_model.dart';

class FundListView extends StatelessWidget {
  const FundListView({
    super.key,
    required this.funds,
  });

  final List<FundModel> funds;

  @override
  Widget build(BuildContext context) {
    final currencyState = context.read<CurrencyCubit>().state;

    // Build a lookup map once instead of searching for every Fund.
    final Map<int, CurrencyModel> currencyMap = {};

    if (currencyState is CurrencyLoaded) {
      for (final currency in currencyState.currencies) {
        currencyMap[currency.currencyId!] = currency;
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: funds.length,
      itemBuilder: (context, index) {
        final fund = funds[index];
        final color = AppColors.lessonColors;
        final currency = currencyMap[fund.currencyId];

        return FundCard(
          fund: fund,
          color: color[index % color.length],
          currencyCode: currency?.currencyCode ?? '',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FundDetails(fund: fund),
              ),
            );
          },
        );
      },
    );
  }
}
