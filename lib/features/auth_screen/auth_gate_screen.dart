import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/features/auth_screen/splash_screen.dart';
import '../../core/cubit/auth/auth_cubit.dart';
import '../../core/cubit/auth/auth_state.dart';
import '../../core/extensions/profile_extension.dart';
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


      builder: (context,state){


        switch(state.status){



          case AuthStatus.initial:

            return const SplashScreen(
              message: 'Checking session...',
            );


          case AuthStatus.loading:

            return const SplashScreen(
              message: 'Signing in...',
            );



          case AuthStatus.unauthenticated:

            return const LoginScreen();



          case AuthStatus.authenticated:


            if(state.profile!.isAdmin){

              return const AdminDashboardScreen();

            }


            return const FundScreen();



          case AuthStatus.failure:

            return const LoginScreen();

        }


      },

    );


  }

}