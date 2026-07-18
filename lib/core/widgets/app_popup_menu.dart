import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/features/about_screen/about_screen.dart';
import 'package:my_money/features/archived_fund_screen/archived_fund_screen.dart';
import 'package:my_money/features/settings_screen/settings_screen.dart';
import '../../features/currency_screen/currency_screen.dart';
import '../constants/app_enums.dart';
import '../cubit/fund/fund_cubit.dart';
import '../repositories/fund_repository.dart';

class AppPopupMenu extends StatelessWidget {
  const AppPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppMenuAction>(
      tooltip: 'Menu',
      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      onSelected: (value) async {
        switch (value) {
          case AppMenuAction.addCurrency:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CurrencyScreen()),
            );
            break;

          case AppMenuAction.archived:
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) =>
                      FundCubit(context.read<FundRepository>())
                        ..getAllArchived(),
                  child: const ArchivedFundScreen(),
                ),
              ),
            );

            if (!context.mounted) return;

            context.read<FundCubit>().getAllActive();
            break;

          case AppMenuAction.settings:
           Navigator.push(context, MaterialPageRoute(builder: (context)=>const SettingsScreen()));
            break;

          case AppMenuAction.about:
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutScreen()));
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: AppMenuAction.addCurrency,
          child: ListTile(
            leading: Icon(Icons.currency_exchange),
            title: Text('Add Currency'),
            contentPadding: EdgeInsets.zero,
          ),
        ),

        const PopupMenuItem(
          value: AppMenuAction.archived,
          child: ListTile(
            leading: Icon(Icons.archive_outlined),
            title: Text('Archived Funds'),
            contentPadding: EdgeInsets.zero,
          ),
        ),

        const PopupMenuDivider(),

        const PopupMenuItem(
          value: AppMenuAction.settings,
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
            contentPadding: EdgeInsets.zero,
          ),
        ),

        const PopupMenuItem(
          value: AppMenuAction.about,
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
