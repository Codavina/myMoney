import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/features/fund_screen/widgets/archived_fund_list_view.dart';
import '../../core/constants/app_assets.dart';
import '../../core/cubit/fund/fund_cubit.dart';
import '../../core/cubit/fund/fund_state.dart';
import '../../core/utils/app_snackbar.dart';
import '../../core/widgets/empty_state.dart';


class ArchivedFundScreen extends StatelessWidget {
  const ArchivedFundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F5F9),
      appBar: AppBar(
        title: const Text('Archived Funds'),
        backgroundColor: const Color(0xffF8FAFC),
        foregroundColor: const Color(0xff1F2937),
        centerTitle: true,
        elevation: 1,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xffE6EAF0)),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<FundCubit, FundState>(
          listener: (context, state) {
            if (state is FundLoaded) {
              if (state.successMessage != null) {
                AppSnackBar.success(context, state.successMessage!);
              }

              if (state.errorMessage != null) {
                AppSnackBar.error(context, state.errorMessage!);
              }
            }

            if (state is FundError) {
              AppSnackBar.error(context, state.errorMessage);
            }
          },

          builder: (context, state) {
            if (state is FundLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FundLoaded) {
              if (state.funds.isEmpty) {
                return const EmptyState(image: AppAssets.emptyArchivedFundImage);
              }

              return ArchivedFundListView(funds: state.funds);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
