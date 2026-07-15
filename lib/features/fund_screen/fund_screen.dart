import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/fund/fund_cubit.dart';
import 'package:my_money/core/cubit/fund/fund_state.dart';
import 'package:my_money/features/fund_screen/widgets/fund_body.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_snackbar.dart';
import '../../core/widgets/app_popup_menu.dart';
import '../../core/widgets/empty_state.dart';
import 'fund_helper/fund_dialog_helper.dart';


class FundScreen extends StatelessWidget {
  const FundScreen({super.key});

  Future<void> _addFund(BuildContext context) async {

    final fund = await openFundDialog(context);

    if (!context.mounted) return;
    if (fund == null) return;
    context.read<FundCubit>().insert(fund);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F5F9),
      appBar: AppBar(
        title: const Text('My Money'),
        backgroundColor: const Color(0xffF8FAFC),
        foregroundColor: const Color(0xff1F2937),
        centerTitle: true,
        elevation: 1,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xffE6EAF0)),
        ),
        actions: const [AppPopupMenu(),]



      ),

      body: SafeArea(
        child: BlocConsumer<FundCubit, FundState>(
          listener: (context, state) {
            if (state is FundLoaded) {
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

            if (state is FundError) {
              AppSnackBar.error(
                context,
                state.errorMessage,
              );
            }
          },
          builder: (context, state) {
            if (state is FundLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FundLoaded) {


              if (state.funds.isEmpty) {
                return const EmptyState(image: AppAssets.emptyFundImage);
              }
              return FundBody(funds: state.funds);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _addFund(context);
        },
        label: const Text(
          'Add Fund',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xffFFFFFF),
          ),
        ),
        backgroundColor: const Color(0xff0088cc),
        icon: const Icon(Icons.add, color: Color(0xffFFFFFF)),
      ),
    );
  }
}


