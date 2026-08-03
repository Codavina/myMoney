import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_money/core/repositories/sync_repository.dart';
import '../cubit/fund/fund_cubit.dart';
import '../extensions/profile_extension.dart';
import '../session/current_user.dart';
import '../theme/app_color_extension.dart';
import '../utils/app_snackbar.dart';
import 'custom_dialog_title.dart';
import 'dialog_title_decoration.dart';
import 'loading_dialog.dart';

class UpdateChecker extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const UpdateChecker({super.key, required this.child, this.onRefresh});

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  bool _checked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_checked) {
      _checked = true;
      _checkForUpdates();
    }
  }

  Future<void> _checkForUpdates() async {
    final authId = CurrentUser.value!.authId;

    if (!mounted) return;
    final hasUpdate = await context.read<SyncRepository>().hasUpdate(authId);

    if (!mounted) return;

    if (hasUpdate) {
      _showUpdateDialog();
    }
  }

  Future<void> _update() async {
    try {
      final syncRepository = context.read<SyncRepository>();
      final fundCubit = context.read<FundCubit>();

      final authId = CurrentUser.value!.authId;

      // Close Dialog "New Update"
      Navigator.pop(context);

      // SHow updating dialog
      LoadingDialog.show(context, message: 'updating'.tr());

      await syncRepository.downloadUserUpdateFile(authId);

      final json = await syncRepository.readUpdateFile();

      await syncRepository.importUser(json);

      await fundCubit.getAllActive(CurrentUser.value!.userId!);

      await syncRepository.deleteLocalUpdateFile();

      await syncRepository.deleteRemoteUpdateFile(authId);

      if (!mounted) return;
      LoadingDialog.hide(context);
      AppSnackBar.success(context, 'updates_imported_successfully'.tr());
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      AppSnackBar.error(context, 'failed_to_update'.tr());
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: DialogTitleDecoration(
              dialogTitle: DialogTitle(title: 'new_update'.tr()),
              color: context.appColors.primary,
            ),
            content: Text('new_update_available'.tr()),
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: context.appColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _update,
                child: Text('Update'.tr()),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (CurrentUser.value!.isAdmin) {
      return widget.child;
    }

    return RefreshIndicator(
      onRefresh: () async {
        final hasInternet = await InternetConnection().hasInternetAccess;

        if (!hasInternet) {
          if (!context.mounted) return;

          AppSnackBar.error(context, 'no_internet_connection'.tr());
          return;
        }
        await _checkForUpdates();

        if (widget.onRefresh != null) {
          await widget.onRefresh!();
        }
      },
      child: widget.child,
    );
  }
}
