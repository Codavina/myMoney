import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth/auth_cubit.dart';
import '../widgets/confirm_signout_dialog.dart';

Future<void> confirmSignOut(BuildContext context) async {
  final confirmed = await showConfirmDialog(
    context,
    title: 'sign_out'.tr(),
    message: 'are_you_sure_you_want_to_sign_out'.tr(),
    confirmText: 'sign_out'.tr(),
    cancelText: 'cancel'.tr(),
  );

  if (!context.mounted || !confirmed) return;

   context.read<AuthCubit>().signOut();

  //if (!context.mounted) return;

  Navigator.of(context).popUntil((route) => route.isFirst);
}