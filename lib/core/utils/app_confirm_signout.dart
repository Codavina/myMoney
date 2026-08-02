import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth/auth_cubit.dart';
import '../widgets/confirm_signout_dialog.dart';

Future<void> confirmSignOut(BuildContext context) async {
  final confirmed = await showConfirmDialog(
    context,
    title: 'Sign Out',
    message: 'Are you sure you want to sign out?',
    confirmText: 'Sign Out',
    cancelText: 'Cancel',
  );

  if (!context.mounted || !confirmed) return;

  context.read<AuthCubit>().signOut();
}