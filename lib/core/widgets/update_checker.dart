import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/repositories/sync_repository.dart';
import '../cubit/fund/fund_cubit.dart';
import '../extensions/profile_extension.dart';
import '../session/current_user.dart';
import '../utils/app_snackbar.dart';
import 'loading_dialog.dart';


class UpdateChecker extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const UpdateChecker({
    super.key,
    required this.child, this.onRefresh,
  });

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

       final hasUpdate =
    await context.read<SyncRepository>().hasUpdate(authId);

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

      // إغلاق Dialog "New Update"
      Navigator.pop(context);

      // إظهار Dialog التحميل
       LoadingDialog.show(
        context,
        message: 'Updating...',
      );

      log('===== START USER UPDATE =====');
      log('AuthId = $authId');

      await syncRepository.downloadUserUpdateFile(authId);

      final json = await syncRepository.readUpdateFile();

      log('===== JSON READ SUCCESS =====');
      log('Keys = ${json.keys}');
      log('User id = ${json['user']['user_id']}');
      log('Funds = ${(json['funds'] as List).length}');
      log('Transactions = ${(json['transactions'] as List).length}');

      await syncRepository.importUser(json);

      log('===== IMPORT COMPLETED =====');

      await fundCubit.getAllActive(
        CurrentUser.value!.userId!,
      );

      await syncRepository.deleteLocalUpdateFile();

      await syncRepository.deleteRemoteUpdateFile(authId);

      if (!mounted) return;

      LoadingDialog.hide(context);

      AppSnackBar.success(
        context,
        'Updates imported successfully.',
      );
    } catch (e) {
      log('===== UPDATE ERROR =====');
      log(e.toString());

      if (!mounted) return;

      LoadingDialog.hide(context);

      AppSnackBar.error(
        context,
        'Failed to update.',
      );
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
            title: const Text('New Update'),
            content: const Text(
              'New updates are available.\nPlease update to continue.',
            ),
            actions: [
              FilledButton(
                onPressed:_update,
                child: const Text('Update'),
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
        await _checkForUpdates();

        if (widget.onRefresh != null) {
          await widget.onRefresh!();
        }
      },
      child: widget.child,
    );
  }
}