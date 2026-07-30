
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

      debugPrint('===== START USER UPDATE =====');
      debugPrint('AuthId = $authId');
      debugPrint('STEP 1 has file');
      await syncRepository.downloadUserUpdateFile(authId);

      debugPrint('STEP 2 downloaded');
      final json = await syncRepository.readUpdateFile();
      debugPrint('STEP 3 read');
      debugPrint('===== JSON READ SUCCESS =====');
      debugPrint('Keys = ${json.keys}');
      debugPrint('User id = ${json['user']['user_id']}');
      debugPrint('Funds = ${(json['funds'] as List).length}');
      debugPrint('Transactions = ${(json['transactions'] as List).length}');

      await syncRepository.importUser(json);

      debugPrint('===== IMPORT COMPLETED =====');


      debugPrint('STEP 4 imported');
      await fundCubit.getAllActive(
        CurrentUser.value!.userId!,
      );
      debugPrint('STEP 5 reload');
      await syncRepository.deleteLocalUpdateFile();
      debugPrint('STEP 6 local deleted');
      await syncRepository.deleteRemoteUpdateFile(authId);
      debugPrint('STEP 7 remote deleted');
      if (!mounted) return;

      LoadingDialog.hide(context);

      AppSnackBar.success(
        context,
        'Updates imported successfully.',
      );
    } catch (e,s) {
      debugPrint('===== UPDATE ERROR =====');
      debugPrint('UPDATE ERROR: $e');
      debugPrint(s.toString());

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