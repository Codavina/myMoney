import 'package:flutter/material.dart';
import 'package:my_money/core/constants/app_colors.dart';

import '../../../core/widgets/app_popup_menu.dart';

class CurrencyListview extends StatelessWidget {
  const CurrencyListview({super.key, required this.title, this.onSelected});

  final String title;
  final void Function(String)? onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            color: AppColors.lightBackground,
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: AppPopUpMenu(onSelected: onSelected),
            ),
          ),
        );
      },
    );
  }
}


