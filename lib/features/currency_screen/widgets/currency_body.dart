import 'package:flutter/material.dart';
import '../../../core/models/currency_model.dart';
import 'currency_header.dart';
import 'currency_listview.dart';

class CurrencyBody extends StatelessWidget {
  const CurrencyBody({
    super.key,
    required this.currencies,
  });


  final List<CurrencyModel> currencies;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurrencyHeader(currencyCount: currencies.length),
        const SizedBox(height: 10),
        Expanded(child: CurrencyListView(currencies: currencies,)),
      ],
    );
  }
}
