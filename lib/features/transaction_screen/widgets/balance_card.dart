import 'package:flutter/material.dart';
import 'package:my_money/core/utils/app_formatter.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.balance});

  final double balance;


  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      color:const Color(0xFFEAF5FC),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
        child: Row(

          children: [
            Text('Sold:', style: text.titleMedium!.copyWith(color: Colors.grey.shade700),textAlign: TextAlign.center,),
           // const Spacer(),
            Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(AppFormatter.money.format(balance), style: text.titleLarge)),
            ),
          ],
        ),
      ),
    );
  }
}
