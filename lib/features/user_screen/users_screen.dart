import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/cubit/fund/fund_cubit.dart';
import '../../core/cubit/user/user_cubit.dart';
import '../../core/cubit/user/user_state.dart';
import '../../core/extensions/profile_extension.dart';
import '../../core/session/selected_user.dart';
import '../fund_screen/fund_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UserError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {

                final user = state.users[index];
                log(
                  'userId=${user.userId}, '
                      'authId=${user.authId}, '
                      'name=${user.fullName}',
                );
                return ListTile(

                  leading: Icon(
                    user.isAdmin
                        ? Icons.admin_panel_settings
                        : Icons.person,
                  ),

                  title: Text(user.fullName),

                  subtitle: Text(user.email),

                  trailing: const Icon(Icons.chevron_right),

                  onTap: () {

                    SelectedUser.value = user;

                    context.read<FundCubit>().getAllActive(user.userId!);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>  FundScreen(ownerId: user.userId!),
                      ),
                    );
                  },

                );

              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}