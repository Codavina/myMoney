import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/fund/fund_cubit.dart';
import 'package:my_money/core/cubit/fund/fund_state.dart';
import 'package:my_money/core/widgets/admin_only.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import 'package:my_money/features/fund_screen/widgets/active_fund_list_view.dart';
import '../../core/constants/app_assets.dart';
import '../../core/repositories/sync_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/session/selected_user.dart';
import '../../core/theme/app_color_extension.dart';
import '../../core/utils/app_snackbar.dart';
import '../../core/widgets/app_popup_menu.dart';
import '../../core/widgets/custom_floating_action_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_dialog.dart';
import 'fund_helper/fund_dialog_helper.dart';

class FundScreen extends StatefulWidget {
  const FundScreen({super.key, required this.ownerId});

  final int ownerId;

  @override
  State<FundScreen> createState() => _FundScreenState();
}

class _FundScreenState extends State<FundScreen> {

  Future<void> _addFund(BuildContext context) async {
    final fund = await openFundDialog(context, ownerId: widget.ownerId);

    if (!context.mounted) return;
    if (fund == null) return;
    context.read<FundCubit>().insert(fund, widget.ownerId);
  }

  Future<void> _pushUpdates() async {
    try {
      LoadingDialog.show(
        context,
        message: 'uploading_updates'.tr(),
      );

      final syncRepository = context.read<SyncRepository>();

      // 1. Create JSON file
      final file = await syncRepository.createUserUpdateFile(
        widget.ownerId,
      );

      // 2. Verify JSON locally
      final json = await syncRepository.readUpdateFile();

      json['currencies'] as List;
      json['funds'] as List;
      json['transactions'] as List;

      // 3. Get user
      if (!mounted) return;

      final user = await context
          .read<UserRepository>()
          .getById(widget.ownerId);

      if (user == null) {
        throw Exception('User not found.');
      }

      // 4. Upload update
      await syncRepository.uploadUserUpdateFile(
        file,
        user.authId,
      );

      // Success
      if (!mounted) return;

      LoadingDialog.hide(context);

      AppSnackBar.success(
        context,
        'updates_pushed_successfully'.tr(),
      );
    } catch (e) {
      if (mounted) {
        LoadingDialog.hide(context);

        AppSnackBar.error(
          context,
          'failed_to_push_updates'.tr(),
        );
      }

      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<FundCubit>().getAllActive(widget.ownerId);
  }

  @override
  void dispose() {
    SelectedUser.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SelectedUser.value = null;
      },
      child: Scaffold(
        backgroundColor: context.appColors.background,
        appBar: CustomAppBar(title: 'funds'.tr(), actions: [
          AdminOnly(
            child: IconButton(
              onPressed: _pushUpdates,
              icon: const Icon(Icons.cloud_upload_outlined),
              tooltip: 'push'.tr(),
            ),
          ),
          AppPopupMenu(ownerId: widget.ownerId),
        ],),

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
                    image: AppAssets.emptyFundImage,
                    scrollable: true,
                  );
                }
                return ActiveFundListView(funds: state.funds);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: AdminOnly(
          child: CustomFloatingActionButton(
            onPressed: () => _addFund(context),
            label: 'add_fund'.tr(),
          ),
        ),
      ),
    );
  }
}
