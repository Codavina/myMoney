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
      LoadingDialog.show(context, message: 'Updating...');

      await syncRepository.downloadUserUpdateFile(authId);

      final json = await syncRepository.readUpdateFile();

      await syncRepository.importUser(json);


      await fundCubit.getAllActive(CurrentUser.value!.userId!);

      await syncRepository.deleteLocalUpdateFile();

      await syncRepository.deleteRemoteUpdateFile(authId);

      if (!mounted) return;
      LoadingDialog.hide(context);
      AppSnackBar.success(context, 'Updates imported successfully.');
    } catch (e) {

      if (!mounted) return;

      LoadingDialog.hide(context);

      AppSnackBar.error(context, 'Failed to update.');
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
              dialogTitle: const DialogTitle(title: 'New Update'),
              color:context.appColors.primary,
            ),
            content: const Text(
              'New Transactions are available.\nPlease update to continue.',
            ),
            actions: [
              FilledButton(style:FilledButton.styleFrom(backgroundColor: context.appColors.primary,shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              )),onPressed: _update, child: const Text('Update'),),
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

          AppSnackBar.error(context, 'No internet connection.');
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
