import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/extensions/string_extensions.dart';
import 'package:my_money/core/models/transaction_model.dart';
import 'package:my_money/features/transaction_screen/widgets/transaction_body.dart';
import '../../core/constants/app_assets.dart';
import '../../core/cubit/fund/fund_cubit.dart';
import '../../core/cubit/transaction/transaction_cubit.dart';
import '../../core/cubit/transaction/transaction_state.dart';
import '../../core/models/fund_model.dart';
import '../../core/widgets/empty_state.dart';
import 'widgets/add_transaction_dialog.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({
    super.key,
    required this.fund,
    this.readOnly = false,
  });

  final FundModel fund;
  final bool readOnly;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  Future<void> _addTransaction() async {
    final transaction = await showDialog<TransactionModel>(
      context: context,
      builder: (_) => AddTransactionDialog(fundId: widget.fund.fundId!),
    );

    if (!mounted || transaction == null) return;

    // Wait until the transaction is inserted and the list is refreshed.
    await context.read<TransactionCubit>().insert(transaction);

    if (!mounted) return;

    // Reload funds to get the updated balance from the trigger.
    context.read<FundCubit>().getAllActive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAFC),
        foregroundColor: const Color(0xff1F2937),
        elevation: 1,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xffE6EAF0)),
        ),

        title: Text(widget.fund.title.toSimpleTitleCase()),
      ),
      body: SafeArea(
        child: BlocConsumer<TransactionCubit, TransactionState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TransactionLoaded) {
              if (state.transactions.isEmpty) {
                return const EmptyState(image: AppAssets.emptyTransactionImage);
              }
              return TransactionBody(
                transactions: state.transactions,
                selectedFund: widget.fund,
              );
            }
            if (state is TransactionError) {
              return const Text('Transaction State: Error');
            }
            return const Text('Transaction State: Initial state');
          },
        ),
      ),
      floatingActionButton: widget.readOnly
          ? null
          : FloatingActionButton.extended(
              onPressed: _addTransaction,
              //shape: const CircleBorder(),
              label: const Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFFFFFF),
                ),
              ),
              icon: const Icon(Icons.add, size: 24),
            ),
    );
  }
}
