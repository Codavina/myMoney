import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
import 'package:my_money/core/cubit/currency/currency_state.dart';
import 'package:my_money/features/currency_screen/widgets/currency_loaded_widget.dart';
import '../../core/constants/app_assets.dart';
import '../../core/models/currency_model.dart';
import '../../core/repositories/currency_repository.dart';
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
    //add();
    context.read<CurrencyCubit>().getAll();
  }

  final currencyRepo = CurrencyRepository();
  List<CurrencyModel> currencies = [];

  Future<void> add() async {
    final result = await currencyRepo.insert(
      const CurrencyModel(currencyCode: 'USD'),
    );
    log(result.toString());
    load();
  }

  Future<void> load() async {
    currencies = await currencyRepo.getAll();
    log(currencies.toString());
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
        elevation: 30,
        backgroundColor: Colors.transparent,
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
            return  CurrencyLoadedWidget(currencies: state.currencies,);
          }
          if (state is CurrencyError) {
            return const Text('Error State');
          }
          return const Text('Initial state');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
