import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/features/auth_screen/splash_screen.dart';
import '../../core/cubit/auth/auth_cubit.dart';
import '../../core/cubit/auth/auth_state.dart';
import '../../core/cubit/fund/fund_cubit.dart';
import '../../core/extensions/profile_extension.dart';
import '../../core/widgets/update_checker.dart';
import '../admin_screen/admin_dashboard_screen.dart';
import '../login_screen/login_screen.dart';
import '../fund_screen/fund_screen.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("AuthGate Screen Build");
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {


        switch (state.status) {
          case AuthStatus.initial:
            return SplashScreen(
              message: 'checking_session'.tr(),
            );

          case AuthStatus.signingIn:
            return const LoginScreen();

          case AuthStatus.signingOut:
            return SplashScreen(
              message: 'signing_out'.tr(),
            );

          case AuthStatus.unauthenticated:
            return const LoginScreen();

          case AuthStatus.authenticated:
            if (state.profile!.isAdmin) {
              return const AdminDashboardScreen();
            }

            return UpdateChecker(
              onRefresh: () async {
                await context
                    .read<FundCubit>()
                    .getAllActive(state.profile!.userId!);
              },
              child: FundScreen(
                ownerId: state.profile!.userId!,
              ),
            );

          case AuthStatus.failure:
            return const LoginScreen();
        }
      },
    );
  }
}


