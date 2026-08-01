import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import 'package:my_money/features/admin_screen/widgets/custom_admin_card.dart';
import 'package:my_money/features/settings_screen/settings_screen.dart';
import '../../core/cubit/auth/auth_cubit.dart';
import '../../core/cubit/user/user_cubit.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/theme/app_color_extension.dart';
import '../currency_screen/currency_screen.dart';
import '../user_screen/users_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: const CustomAppBar(title: 'Admin Dashboard'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
            mainAxisSpacing: 16,
          ),
          children: [
            CustomAdminCard(
              title: 'Users',
              icon: Icons.people,
              borderColor: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) =>
                          UserCubit(context.read<UserRepository>())
                            ..getAllUsers(),
                      child: const UsersScreen(),
                    ),
                  ),
                );
              },
            ),
            CustomAdminCard(
              title: 'Currencies',
              icon: Icons.currency_exchange,
              borderColor: Colors.amber,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CurrencyScreen(),
                  ),
                );
              },
            ),
            CustomAdminCard(
              title: 'Settings',
              icon: Icons.settings,
              borderColor: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            CustomAdminCard(
              title: 'About',
              icon: Icons.info_outline,
              borderColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            CustomAdminCard(
              title: 'Backup',
              icon: Icons.dataset_outlined,
              borderColor: Colors.brown,
              onTap: () {

              },
            ),
            CustomAdminCard(
              title: 'Sign Out',
              icon: Icons.logout,
              borderColor: Colors.red,
              onTap: () => context.read<AuthCubit>().signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
