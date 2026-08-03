import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
import 'package:my_money/core/cubit/fund/fund_cubit.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/features/fund_screen/widgets/swipe_background.dart';
import 'package:my_money/features/transaction_screen/transaction_screen.dart';
import '../../../core/cubit/currency/currency_state.dart';
import '../../../core/cubit/transaction/transaction_cubit.dart';
import '../../../core/extensions/profile_extension.dart';
import '../../../core/models/currency_model.dart';
import '../../../core/repositories/transaction_repository.dart';
import '../../../core/session/current_user.dart';
import '../../../core/theme/app_color_extension.dart';
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
        title: 'archive_fund'.tr(),
        message: 'are_you_sure_you_want_to_archive'.tr(),
        textToAction: fund.title.toUpperCase(),
        color: context.appColors.subtitle,
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
          return const Center(child: CircularProgressIndicator());
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

            return Dismissible(
              key: ValueKey(fund.fundId),
              direction: CurrentUser.value!.isAdmin
                  ? DismissDirection.horizontal
                  : DismissDirection.none,
              secondaryBackground: SwipeBackground(
                color: Colors.grey,
                icon: Icons.archive,
                text: 'archive'.tr(),
                alignment: Alignment.centerRight,
              ),
              background: SwipeBackground(
                color: Colors.teal,
                icon: Icons.edit,
                text: 'edit'.tr(),
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
                  final updatedFund = await openFundDialog(
                    context,
                    fund: fund,
                    ownerId: 1,
                  );

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
