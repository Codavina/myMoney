import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyOperations extends StatelessWidget {

  const EmptyOperations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return  Center(

      child: Text(
        'no_transactions_yet'.tr(),
      ),

    );
  }
}