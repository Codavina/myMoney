import 'package:flutter/material.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/features/fund_screen/widgets/fund_card.dart';
import 'package:my_money/features/funds_details_page/UI/fund_details_page.dart';

class FundListView extends StatelessWidget {
  const FundListView({super.key, required this.funds});

  final List<FundModel> funds;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          funds.length,
          (int index) => FundCard(
            fund: funds[index],
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FundDetails(fund: funds[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
