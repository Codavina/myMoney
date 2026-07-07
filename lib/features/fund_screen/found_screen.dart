import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/fund/fund_cubit.dart';
import 'package:my_money/core/cubit/fund/fund_state.dart';
import 'package:my_money/core/models/fund_model.dart';

import '../../core/constants/app_assets.dart';
import '../../core/widgets/empty_state.dart';
import '../home_page/widgets/add_fund_dialog.dart';

class FoundScreen extends StatelessWidget {
  const FoundScreen({super.key});

  Future<void> _addFund(BuildContext context) async {
    final FundModel? fund = await showDialog<FundModel>(
      context: context,
      builder: (_) => const AddFundDialog(),
    );

    if (fund == null) return;
    context.read<FundCubit>().insert(fund);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('My Money')),
      body: BlocConsumer<FundCubit, FundState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FundLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FundLoaded) {

            if (state.funds.isEmpty) {
              return const EmptyState(image: AppAssets.emptyFundImage);
            }
            return  Text('has data');//FundBody(currencies: state.funds,);
          }
          if (state is FundError) {
            return const Text('Error State');
          }
          return const Text('Initial state');
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){_addFund(context);},
        label: const Text('Fund'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
