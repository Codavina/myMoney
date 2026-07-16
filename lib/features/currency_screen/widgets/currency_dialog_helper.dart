import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/models/currency_model.dart';
import 'package:my_money/features/currency_screen/widgets/add_currency_dialog.dart';

import '../../../core/cubit/currency/currency_cubit.dart';
import '../../../core/cubit/currency/currency_state.dart';

Future<CurrencyModel?> openCurrencyDialog(
  BuildContext context, {
  CurrencyModel? currency,
}) async {
  final state = context.read<CurrencyCubit>().state;

  if (state is! CurrencyLoaded) {
    return null;
  }

  return showDialog<CurrencyModel>(
    context: context,
    builder: (_) => AddCurrencyDialog(currency: currency),
  );
}
