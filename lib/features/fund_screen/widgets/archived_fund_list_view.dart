import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/features/fund_screen/widgets/swipe_background.dart';
import '../../../core/cubit/currency/currency_cubit.dart';
import '../../../core/cubit/currency/currency_state.dart';
import '../../../core/cubit/fund/fund_cubit.dart';
import '../../../core/cubit/transaction/transaction_cubit.dart';
import '../../../core/models/currency_model.dart';
import '../../../core/models/fund_model.dart';
import '../../../core/repositories/transaction_repository.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../currency_screen/currency_info.dart';
import '../../transaction_screen/transaction_screen.dart';
import 'fund_card.dart';

class ArchivedFundListView extends StatelessWidget {
  const ArchivedFundListView({super.key, required this.funds});
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

  Future<bool> _confirmDelete(BuildContext context, FundModel fund) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmDialog(
        title: 'Delete Fund',
        message:
        'Are you sure you want to delete "${fund.title.toUpperCase()}"?',
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

            return Dismissible(
              key: ValueKey(fund.fundId),
              direction: DismissDirection.horizontal,
              secondaryBackground: const SwipeBackground(
                color: Colors.red,
                icon: Icons.delete,
                text: 'Delete',
                alignment: Alignment.centerRight,
              ),
              background:  const SwipeBackground(
                color: Colors.teal,
                icon: Icons.unarchive,
                text: 'Restore',
                alignment: Alignment.centerLeft,
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  final confirmed = await _confirmDelete(context, fund);

                  if (confirmed) {
                    fundCubit.delete(fund.fundId!);
                  }

                  return confirmed;
                }

                if (direction == DismissDirection.startToEnd) {

                    fundCubit.restore(fund.fundId!);


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
