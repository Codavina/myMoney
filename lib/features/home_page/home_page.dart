import 'package:flutter/material.dart';
import 'package:my_money/core/constants/app_enums.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});


  Color navigationColor(EnNavigationPages page) {
    switch (page) {
      case EnNavigationPages.home:
        return  Colors.teal;

      case EnNavigationPages.notes:
        return Colors.blue;

      case EnNavigationPages.settings:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(


    );
  }
}
