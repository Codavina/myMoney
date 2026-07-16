import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
import 'package:my_money/core/cubit/fund/fund_cubit.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/features/fund_screen/widgets/swipe_background.dart';
import 'package:my_money/features/transaction_screen/transaction_screen.dart';
import '../../../core/cubit/currency/currency_state.dart';
import '../../../core/cubit/transaction/transaction_cubit.dart';
import '../../../core/models/currency_model.dart';
import '../../../core/repositories/transaction_repository.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../currency_screen/currency_info.dart';
import '../fund_helper/fund_dialog_helper.dart';
import 'fund_card.dart';

class ActiveFundListView extends StatelessWidget {
  const ActiveFundListView({super.key, required this.funds});

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

  Future<bool> _confirmArchive(BuildContext context, FundModel fund) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmDialog(
        title: 'Archive Fund',
        message:
            'Are you sure you want to archive "${fund.title.toUpperCase()}"?',
        isArchived: true,
      ),
    );

    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final fundCubit = context.read<FundCubit>();
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, state) {
        // Build a lookup map once instead of searching for every Fund.

        if (state is CurrencyLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is! CurrencyLoaded) {
          return const SizedBox.shrink();
        }

        final currencyMap = <int, CurrencyModel>{};

        for (final currency in state.currencies) {
          currencyMap[currency.currencyId!] = currency;
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
            debugPrint(state.runtimeType.toString());
            return Dismissible(
              key: ValueKey(fund.fundId),
              direction: DismissDirection.horizontal,
              secondaryBackground: const SwipeBackground(
                color: Colors.grey,
                icon: Icons.archive,
                text: 'Archive',
                alignment: Alignment.centerRight,
              ),
              background: const SwipeBackground(
                color: Colors.blue,
                icon: Icons.edit,
                text: 'Edit',
                alignment: Alignment.centerLeft,
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  final confirmed = await _confirmArchive(context, fund);

                  if (confirmed) {
                    fundCubit.archive(fund.fundId!);
                  }

                  return confirmed;
                }

                if (direction == DismissDirection.startToEnd) {
                  final updatedFund = await openFundDialog(context, fund: fund);

                  if (updatedFund != null) {
                    fundCubit.update(updatedFund);
                  }

                  return false;
                }

                return false;
              },

              child: FundCard(
                info: info.symbol,
                flag: info.flag,
                fund: fund,
                onPressed: () => _openTransactions(context, fund),
              ),
            );
          },
        );
      },
    );
  }
}
