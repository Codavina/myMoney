import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
import 'package:my_money/core/cubit/currency/currency_state.dart';
import 'package:my_money/core/models/currency_model.dart';
import 'package:my_money/features/currency_screen/widgets/add_currency_dialog.dart';
import 'package:my_money/features/currency_screen/widgets/currency_body.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/empty_state.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {



  @override
  void initState() {
    super.initState();

    context.read<CurrencyCubit>().getAll();
  }

  Future<void> _addCurrency()async{

    final CurrencyModel? currency = await showDialog<CurrencyModel>(
      context: context,
      builder: (_) => const AddCurrencyDialog(),
    );
    if(!mounted)return;
    if(currency==null) return;
    context.read<CurrencyCubit>().insert(currency);





  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Currency Page',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        backgroundColor:  const Color(0xfff3f3ef),
      ),
      body: BlocConsumer<CurrencyCubit, CurrencyState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CurrencyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CurrencyLoaded) {

            if (state.currencies.isEmpty) {
              return const EmptyState(image: AppAssets.emptyCurrencyImage);
            }
            return  CurrencyBody(currencies: state.currencies,);
          }
          if (state is CurrencyError) {
            return const Text('Error State');
          }
          return const Text('Initial state');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCurrency,
        child: const Icon(Icons.add),
      ),
    );
  }
}
