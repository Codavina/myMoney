import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';
import '../extensions/profile_extension.dart';

class AdminOnly extends StatelessWidget {

  final Widget child;

  const AdminOnly({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return BlocSelector<AuthCubit, AuthState, bool>(

      selector: (state) =>
      state.profile?.isAdmin ?? false,

      builder: (_, isAdmin) {

        if (!isAdmin) {

          return const SizedBox.shrink();

        }

        return child;

      },

    );

  }

}