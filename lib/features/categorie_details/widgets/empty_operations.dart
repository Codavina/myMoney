import 'package:flutter/material.dart';

class EmptyOperations extends StatelessWidget {

  const EmptyOperations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return const Center(

      child: Text(
        "No transactions yet",
      ),

    );
  }
}