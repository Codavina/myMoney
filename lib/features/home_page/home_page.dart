import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/constants/app_enums.dart';
import 'package:my_money/features/currency_screen/currency_screen.dart';
import 'package:my_money/features/home_page/setting_screen.dart';
import '../../core/cubit/navigation/navigation_cubit.dart';
import '../../core/cubit/navigation/navigation_state.dart';
import '../fund_screen/fund_screen.dart';


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
    return Scaffold(

      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {

          switch (state.page) {

            case EnNavigationPages.home:
              return const FundScreen();

            case EnNavigationPages.notes:
              return const CurrencyScreen();

            case EnNavigationPages.settings:
              return const SettingScreen();
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),

            decoration: BoxDecoration(
              color: navigationColor(state.page),
            ),

            child: NavigationBar(
              backgroundColor: Colors.transparent,

              indicatorColor: Colors.white,

              selectedIndex: state.page.index,

              onDestinationSelected: (index) {

                context.read<NavigationCubit>().changePage(
                  EnNavigationPages.values[index],
                );
              },

              destinations: const [

                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: "Home",
                ),

                NavigationDestination(
                  icon: Icon(Icons.note_alt_outlined),
                  selectedIcon: Icon(Icons.note_alt),
                  label: "Notes",
                ),

                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
