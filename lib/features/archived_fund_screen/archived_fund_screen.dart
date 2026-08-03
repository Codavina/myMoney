import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import 'package:my_money/features/archived_fund_screen/widgets/archived_fund_list_view.dart';
import '../../core/constants/app_assets.dart';
import '../../core/cubit/fund/fund_cubit.dart';
import '../../core/cubit/fund/fund_state.dart';
import '../../core/theme/app_color_extension.dart';
import '../../core/utils/app_snackbar.dart';
import '../../core/widgets/empty_state.dart';

class ArchivedFundScreen extends StatefulWidget {
  const ArchivedFundScreen({super.key, required this.ownerId});
  final int ownerId;

  @override
  State<ArchivedFundScreen> createState() => _ArchivedFundScreenState();
}

class _ArchivedFundScreenState extends State<ArchivedFundScreen> {

  @override
  void initState() {

    super.initState();
    context.read<FundCubit>().getAllArchived(widget.ownerId);
  }
  @override
  Widget build(BuildContext context) {
    debugPrint("Archived Fund Screen Build");
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar:CustomAppBar(title: 'archived_funds'.tr()),
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
                return const EmptyState(
                  image: AppAssets.emptyArchivedFundImage,
                );
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
