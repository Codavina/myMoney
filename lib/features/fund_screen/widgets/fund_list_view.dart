import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
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
    return BlocBuilder<CurrencyCubit,CurrencyState>(
      builder: (context, state) {
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
            final gradian1 = AppColors.gradianColor1;
            final gradian2 = AppColors.gradianColor2;
            final currency = currencyMap[fund.currencyId];
            final info =
                currenciesInfo[currency?.currencyCode.toUpperCase()] ??
                unknownCurrency;

            return FundCard(

              flag: info.flag,
              fund: fund,
              backgroundColor: color[index % color.length],
              gradian1: gradian1[index % gradian1.length],
              gradian2: gradian2[index % gradian2.length],
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
