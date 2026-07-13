import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/features/fund_screen/widgets/fund_card.dart';
import 'package:my_money/features/transaction_screen/transaction_screen.dart';
import '../../../core/cubit/currency/currency_state.dart';
import '../../../core/cubit/transaction/transaction_cubit.dart';
import '../../../core/models/currency_model.dart';
import '../../../core/repositories/transaction_repository.dart';
import '../../currency_screen/currency_info.dart';

class FundListView extends StatelessWidget {
  const FundListView({super.key, required this.funds});

  final List<FundModel> funds;

  void _openTransactions(BuildContext context, FundModel fund) {
    final repository = context.read<TransactionRepository>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => TransactionCubit(repository)..getByFund(fund.fundId!),
          child: TransactionScreen(fund: fund),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyCubit, CurrencyState>(
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
            final currency = currencyMap[fund.currencyId];
            final info =
                currenciesInfo[currency?.currencyCode.toUpperCase()] ??
                unknownCurrency;

            return FundCard(
              info: info.symbol,
              flag: info.flag,
              fund: fund,
              //currencyCode: currency?.currencyCode ?? '',
              onPressed: () => _openTransactions(context, fund),
            );
          },
        );
      },
    );
  }
}
