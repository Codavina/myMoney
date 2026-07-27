import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/repositories/sync_repository.dart';

import '../repositories/user_repository.dart';
import '../session/current_user.dart';


class UpdateChecker extends StatefulWidget {
  final Widget child;

  const UpdateChecker({
    super.key,
    required this.child,
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
                onPressed: () async {
                  log('===== onPressed start update_checker widget ===== ');
                  final authId = CurrentUser.value!.authId;
                log('authId: $authId');
                  await context
                      .read<SyncRepository>()
                      .downloadUserUpdateFile(authId);

                  if (!mounted) return;
                  final json = await context
                      .read<SyncRepository>()
                      .readUpdateFile();

                  if (!mounted) return;
                  await context
                      .read<SyncRepository>()
                      .importUser(json);

                  if (!mounted) return;
                  final user = await context
                      .read<UserRepository>()
                      .getByAuthId(CurrentUser.value!.authId);

                  debugPrint(user.toString());
                  debugPrint(json.toString());
                  log("downloadUserUpdateFile was called");

                  if (!mounted) return;
                  Navigator.pop(context);
                },
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
    return widget.child;
  }
}