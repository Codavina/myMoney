import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/extensions/string_extensions.dart';
import 'package:my_money/core/models/transaction_model.dart';
import 'package:my_money/core/widgets/admin_only.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import 'package:my_money/features/transaction_screen/widgets/transaction_body.dart';
import '../../core/constants/app_assets.dart';
import '../../core/cubit/fund/fund_cubit.dart';
import '../../core/cubit/transaction/transaction_cubit.dart';
import '../../core/cubit/transaction/transaction_state.dart';
import '../../core/models/fund_model.dart';
import '../../core/theme/app_color_extension.dart';
import '../../core/utils/app_snackbar.dart';
import '../../core/widgets/custom_floating_action_button.dart';
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
  context.read<FundCubit>().getAllActive(widget.fund.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Transaction Screen Build");
    return Scaffold(
      backgroundColor:  context.appColors.background,
      appBar: CustomAppBar(title: widget.fund.title.toSimpleTitleCase()),
      body: SafeArea(
        child: BlocConsumer<TransactionCubit, TransactionState>(
          listener: (context, state) {

            if (state is TransactionLoaded) {
              if (state.successMessage != null) {
                AppSnackBar.success(
                  context,
                  state.successMessage!,
                );
              }

              if (state.errorMessage != null) {
                AppSnackBar.error(
                  context,
                  state.errorMessage!,
                );
              }
            }

            if (state is TransactionError) {
              AppSnackBar.error(
                context,
                state.errorMessage,
              );
            }
          },
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
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: widget.readOnly
          ? null
          : AdminOnly(
            child: CustomFloatingActionButton(
              onPressed: () => _addTransaction(),
              label: 'add_transaction'.tr(),
            ),
          ),
    );
  }
}
