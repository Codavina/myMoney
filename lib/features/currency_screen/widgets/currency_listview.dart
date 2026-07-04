import 'package:flutter/material.dart';
import 'package:my_money/core/constants/app_colors.dart';

class CurrencyListview extends StatelessWidget {
  const CurrencyListview({super.key, required this.title});

  final String title;

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
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle selection
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 4),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red.shade700),
                        const SizedBox(width: 4),
                        const Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
