import 'package:flutter/material.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/features/fund_screen/widgets/fund_list_view.dart';

class FundBody extends StatelessWidget {
  const FundBody({super.key, required this.funds});

  final List<FundModel> funds;


  @override
  Widget build(BuildContext context) {

    return FundListView(funds: funds);
  }
}
