import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/core/models/transaction_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/cubit/fund/fund_cubit.dart';
import '../../../core/cubit/fund/fund_state.dart';
import 'balance_card.dart';
import 'operations_table.dart';

class TransactionBody extends StatelessWidget {
  const TransactionBody({
    super.key,
    required this.transactions,
    required this.selectedFund,
  });

  final List<TransactionModel> transactions;
  final FundModel selectedFund;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<FundCubit, FundState>(
              builder: (context, state) {
                if (state is! FundLoaded) {
                  return const SizedBox.shrink();
                }

                final currentFund = state.funds.firstWhere(
                  (f) => f.fundId == selectedFund.fundId,
                );
                final color = AppColors.fundCardColor;
                return BalanceCard(
                  balance: currentFund.balance,
                  backgroundColor: color[currentFund.fundId!-1 % color.length],
                );
              },
            ),

            const SizedBox(height: 16),

            Expanded(child: OperationsTable(transactions: transactions)),
          ],
        ),
      ),
    );
  }
}
