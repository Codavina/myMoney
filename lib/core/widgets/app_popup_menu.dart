import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/features/archived_fund_screen/archived_fund_screen.dart';
import 'package:my_money/features/settings_screen/settings_screen.dart';
import '../constants/app_enums.dart';
import '../cubit/fund/fund_cubit.dart';
import '../repositories/fund_repository.dart';

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

    await context.read<FundCubit>().getAllActive(ownerId!);
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
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppMenuAction.archived,
          child: ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: Text('archived_funds'.tr()),
            contentPadding: EdgeInsets.zero,
          ),
        ),

        PopupMenuItem(
          value: AppMenuAction.settings,
          child: ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text('settings'.tr()),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
