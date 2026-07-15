import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cubit/currency/currency_cubit.dart';
import '../../../core/cubit/currency/currency_state.dart';
import '../../../core/models/fund_model.dart';
import '../widgets/add_fund_dialog.dart';

Future<FundModel?> openFundDialog(
    BuildContext context, {
      FundModel? fund,
    }) async {

  final state = context.read<CurrencyCubit>().state;

  if (state is! CurrencyLoaded) {
    return null;
  }

  return showDialog<FundModel>(
    context: context,
    builder: (_) => AddFundDialog(
      fund: fund,
      currencies: state.currencies,
    ),
  );
}