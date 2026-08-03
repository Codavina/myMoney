import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import '../../core/cubit/fund/fund_cubit.dart';
import '../../core/cubit/user/user_cubit.dart';
import '../../core/cubit/user/user_state.dart';
import '../../core/extensions/profile_extension.dart';
import '../../core/session/selected_user.dart';
import '../../core/theme/app_color_extension.dart';
import '../fund_screen/fund_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("User Screen Build");
    return Scaffold(
     backgroundColor:  context.appColors.background,
      appBar: CustomAppBar(
        title: 'users'.tr(),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserError) {
            return Center(child: Text(state.message));
          }

          if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];

                return ListTile(
                  leading: Icon(
                    user.isAdmin ? Icons.admin_panel_settings : Icons.person,
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
                        builder: (_) => FundScreen(ownerId: user.userId!),
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
