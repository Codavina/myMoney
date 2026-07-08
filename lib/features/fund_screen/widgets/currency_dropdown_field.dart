import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/cubit/currency/currency_cubit.dart';
import '../../../core/cubit/currency/currency_state.dart';
import '../../../core/models/currency_model.dart';
import '../../currency_screen/currency_info.dart';

class CurrencyDropdownField extends StatelessWidget {
  const CurrencyDropdownField({
    super.key,
    required this.selectedCurrency,
    required this.onChanged,
  });

  final CurrencyModel? selectedCurrency;
  final void Function(CurrencyModel?)? onChanged;

  @override
  Widget build(BuildContext context) {
    // Listen to CurrencyCubit and rebuild only the dropdown
    // whenever the list of currencies changes.
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, state) {
        if (state is CurrencyLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is! CurrencyLoaded) {
          return const Text('Unable to load currencies.');
        }

        return DropdownButtonFormField<CurrencyModel>(
          initialValue: selectedCurrency,

          decoration: const InputDecoration(
            labelText: 'Currency',
            border: OutlineInputBorder(),
          ),

          validator: (value) {
            if (value == null) {
              return 'Please select a currency';
            }
            return null;
          },

          onChanged: onChanged,

          items: state.currencies.map((currency) {
            // Get currency information such as flag and full name.
            final info =
                currenciesInfo[currency.currencyCode.toUpperCase()] ??
                    unknownCurrency;

            return DropdownMenuItem<CurrencyModel>(
              value: currency,
              child: Row(
                children: [
                  SvgPicture.asset(info.flag, width: 24, height: 24),

                  const SizedBox(width: 10),

                  Text(currency.currencyCode.toUpperCase()),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}