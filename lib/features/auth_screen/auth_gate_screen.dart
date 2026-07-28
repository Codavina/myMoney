import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/features/auth_screen/splash_screen.dart';
import '../../core/cubit/auth/auth_cubit.dart';
import '../../core/cubit/auth/auth_state.dart';
import '../../core/extensions/profile_extension.dart';
import '../../core/widgets/update_checker.dart';
import '../admin_screen/admin_dashboard_screen.dart';
import '../login_screen/login_screen.dart';
import '../fund_screen/fund_screen.dart';




class AuthGateScreen extends StatelessWidget {


  const AuthGateScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        log("AuthGate -> ${state.status}");
        switch (state.status) {
          case AuthStatus.initial:
            return const SplashScreen(
              message: 'Checking session...',
            );

          case AuthStatus.signingIn:
            return const SplashScreen(
              message: 'Signing in...',
            );

          case AuthStatus.signingOut:
            return const SplashScreen(
              message: 'Signing out...',
            );

          case AuthStatus.unauthenticated:
            return const LoginScreen();

          case AuthStatus.authenticated:
            if (state.profile!.isAdmin) {
              return const AdminDashboardScreen();
            }
            return UpdateChecker(
              child: FundScreen(
                ownerId: state.profile!.userId!,
              ),
            );


          case AuthStatus.failure:
            log(state.message!);
            return const SplashScreen(
              message: 'Unexpected error...',
            );
        }
      },
    );


  }

}