import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/cubit/fund/fund_cubit.dart';
import '../../core/cubit/fund/fund_state.dart';

class ArchivedFundScreen extends StatelessWidget {
  const ArchivedFundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F5F9),
      appBar: AppBar(
        title: const Text('Archived Funds'),
        backgroundColor: const Color(0xffF8FAFC),
        foregroundColor: const Color(0xff1F2937),
        centerTitle: true,
        elevation: 1,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xffE6EAF0)),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<FundCubit, FundState>(
          listener: (context, state) {},
          builder: (context, state) {},
        ),
      ),
    );
  }
}
