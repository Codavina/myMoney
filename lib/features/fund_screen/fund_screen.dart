import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/fund/fund_cubit.dart';
import 'package:my_money/core/cubit/fund/fund_state.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/features/currency_screen/currency_screen.dart';
import 'package:my_money/features/fund_screen/widgets/fund_body.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/empty_state.dart';
import 'widgets/add_fund_dialog.dart';

class FundScreen extends StatelessWidget {
  const FundScreen({super.key});

  Future<void> _addFund(BuildContext context) async {
    final FundModel? fund = await showDialog<FundModel>(
      context: context,
      builder: (_) => const AddFundDialog(),
    );

    if (!context.mounted) return;
    if (fund == null) return;
    context.read<FundCubit>().insert(fund);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text('My Money', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF9B59B6), Color(0xFFC36FE6)],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CurrencyScreen()),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
        //iconTheme: const IconThemeData(color: AppColors.error),
      ),

      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.bgFundCard),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),

          child: BlocConsumer<FundCubit, FundState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is FundLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is FundLoaded) {
                if (state.funds.isEmpty) {
                  return const EmptyState(image: AppAssets.emptyFundImage);
                }
                return FundBody(funds: state.funds);
              }
              if (state is FundError) {
                return const Text('Fund State: Error');
              }
              return const Text('Fund State: Initial state');
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _addFund(context);
        },
        label: const Text(
          'Add Fund',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
   
        icon: const Icon(Icons.add),
      ),
    );
  }
}
