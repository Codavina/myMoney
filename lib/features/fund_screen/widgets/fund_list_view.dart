import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/features/fund_screen/widgets/fund_card.dart';
import 'package:my_money/features/transaction_screen/transaction_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/cubit/currency/currency_state.dart';
import '../../../core/models/currency_model.dart';
import '../../currency_screen/currency_info.dart';

class FundListView extends StatelessWidget {
  const FundListView({super.key, required this.funds});

  final List<FundModel> funds;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      builder: (BuildContext context, state) {
        // Build a lookup map once instead of searching for every Fund.
        final currencyMap = <int, CurrencyModel>{};

        if (state is CurrencyLoaded) {
          for (final currency in state.currencies) {
            currencyMap[currency.currencyId!] = currency;
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: funds.length,
          itemBuilder: (context, index) {
            final fund = funds[index];
            final color = AppColors.fundCardColor;
            final currency = currencyMap[fund.currencyId];
            final info =
                currenciesInfo[currency?.currencyCode.toUpperCase()] ??
                unknownCurrency;

            return FundCard(
              flag: info.flag,
              fund: fund,
              backgroundColor: color[index % color.length],
              currencyCode: currency?.currencyCode ?? '',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransactionScreen(fund: fund),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
