import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/core/models/transaction_model.dart';
import '../../../core/cubit/fund/fund_cubit.dart';
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
            FutureBuilder<FundModel?>(
              future: context.read<FundCubit>().getById(selectedFund.fundId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final fund = snapshot.data!;

                return BalanceCard(
                  balance: fund.balance,

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
