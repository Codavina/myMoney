import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/features/archived_fund_screen/archived_fund_screen.dart';
import 'package:my_money/features/settings_screen/settings_screen.dart';
import '../constants/app_enums.dart';
import '../cubit/fund/fund_cubit.dart';
import '../repositories/fund_repository.dart';
import '../utils/app_confirm_signout.dart';


class AppPopupMenu extends StatelessWidget {
  const AppPopupMenu({super.key, this.ownerId});

  final int? ownerId;

  Future<void> _openArchivedFunds(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) =>
          FundCubit(context.read<FundRepository>())
            ..getAllArchived(ownerId!),
          child: ArchivedFundScreen(ownerId: ownerId!),
        ),
      ),
    );

    if (!context.mounted) return;

    context.read<FundCubit>().getAllActive(ownerId!);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppMenuAction>(
      tooltip: 'Menu',
      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      onSelected: (value) async {
        switch (value) {
          case AppMenuAction.archived:
            await _openArchivedFunds(context);
            break;

          case AppMenuAction.settings:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
            break;

          case AppMenuAction.logOut:
            await confirmSignOut(context);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: AppMenuAction.archived,
          child: ListTile(
            leading: Icon(Icons.archive_outlined),
            title: Text('Archived Funds'),
            contentPadding: EdgeInsets.zero,
          ),
        ),

        const PopupMenuItem(
          value: AppMenuAction.settings,
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        //

        const PopupMenuDivider(),
        const PopupMenuItem(
          value: AppMenuAction.logOut,
          child: ListTile(
            leading: Icon(Icons.logout_outlined, color: Colors.red),
            title: Text('Log Out'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
