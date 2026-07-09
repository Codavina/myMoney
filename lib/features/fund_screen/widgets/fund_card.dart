import 'package:flutter/material.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:svg_flutter/svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_formatter.dart';

class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.onPressed,
    required this.currencyCode,
    required this.backgroundColor,
    required this.flag,
  });

  final FundModel fund;
  final VoidCallback? onPressed;
  final String currencyCode;
  final Color backgroundColor;
  final String flag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.2,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
            topRight: Radius.circular(48),
          ),
          color: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
          child: Row(

            children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(padding: const EdgeInsets.symmetric(
          horizontal: 16,
            vertical: 8,
          ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Text(
                  fund.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              Text(
                '${AppFormatter.money.format(fund.balance)} ${currencyCode.toUpperCase()}',
                style: const TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.bold),//Theme.of(context).textTheme.titleLarge,

              ),
            ],),
            const Spacer(),
           Align(
             alignment: Alignment.centerRight,
             child: IconButton(
               onPressed: onPressed,
               icon: const Icon(Icons.arrow_forward_ios, size: 36),
             ),),

          ],),
        ),
      ),
    );
  }
}

/*
* Card(
        color: backgroundColor,
        child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              fund.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),

              child: Text(
                '${AppFormatter.money.format(fund.balance)} ${currencyCode.toUpperCase()}',
                style: TextStyle(fontSize: 16),//Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),

          ),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),

                child: SvgPicture.asset(flag, fit: BoxFit.contain),
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward_ios, size: 36),
          ),
        ),
      ),
* */
