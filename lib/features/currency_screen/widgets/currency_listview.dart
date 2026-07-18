import 'package:flutter/material.dart';
import 'package:my_money/core/constants/app_colors.dart';
import 'package:my_money/core/models/currency_model.dart';
import 'package:my_money/features/currency_screen/widgets/currency_dialog_helper.dart';
import 'package:svg_flutter/svg.dart';
import '../../../core/cubit/currency/currency_cubit.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/currency_popup_menu.dart';
import '../currency_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyListView extends StatelessWidget {
  const CurrencyListView({super.key, required this.currencies});

  final List<CurrencyModel> currencies;

  Future<void> _confirmDelete(
    BuildContext context,
    CurrencyModel currency,
  ) async {
    final cubit = context.read<CurrencyCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {

        return AppConfirmDialog(
          title: 'Delete Currency',
          message:
              'Are you sure you want to delete ',
          textToAction: currency.currencyCode.toUpperCase(),
          color: Colors.red.shade400,
        );
      },
    );

    if (confirmed == true) {
      cubit.delete(currency.currencyId!);
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    CurrencyModel currency,
  ) async {
    final currencyCubit = context.read<CurrencyCubit>();
    final updatedCurrency = await openCurrencyDialog(
      context,
      currency: currency,
    );

    if (updatedCurrency != null) {
      currencyCubit.update(updatedCurrency);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: currencies.length,
      itemBuilder: (context, i) {
        final currency = currencies[i];

        final info =
            currenciesInfo[currency.currencyCode.toUpperCase()] ??
            unknownCurrency;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            color: AppColors.lightBackground,
            elevation: 0,
            child: ListTile(
              title: Text(
                currency.currencyCode.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(info.name),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),

                    child: SvgPicture.asset(info.flag, fit: BoxFit.contain),
                  ),
                ),
              ),
              trailing: CurrencyPopUpMenu(
                onSelected: (action) async {
                  switch (action) {
                    case MenuAction.edit:
                      _showEditDialog(context, currency);
                      break;

                    case MenuAction.delete:
                      _confirmDelete(context, currency);
                      break;
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
