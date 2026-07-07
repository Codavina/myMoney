import 'package:flutter/material.dart';
import 'package:my_money/core/constants/app_colors.dart';
import 'package:my_money/core/models/currency_model.dart';
import 'package:svg_flutter/svg.dart';
import '../../../core/cubit/currency/currency_cubit.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/app_popup_menu.dart';
import '../currency_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyListView extends StatelessWidget {
  const CurrencyListView({super.key, required this.currencies});

  final List<CurrencyModel> currencies;

  Future<void> _confirmDelete(BuildContext context,CurrencyModel currency,) async {
    final cubit = context.read<CurrencyCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmDialog(
        title: 'Delete Currency',
        message: 'Are you sure you want to delete "${currency.currencyCode.toUpperCase()}"?',
      ),
    );

    if (confirmed == true) {
      cubit.delete(currency.currencyId!);
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
            elevation: 0,

            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            color: AppColors.lightBackground,
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
              trailing: AppPopUpMenu(
                onSelected: (action) async {
                  switch (action) {
                    case MenuAction.edit:
                      // _showEditDialog(currency);
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

  Container buildCurrencyId(CurrencyModel currency) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: LinearGradient(
          colors: [Color(0xff1B64C3), Color(0xff4a94e1)],
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          '${currency.currencyId}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
