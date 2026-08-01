import 'package:flutter/material.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import '../../core/theme/app_color_extension.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: const CustomAppBar(title: 'Settings'),
      body: const Center(
        child: Text('Setting Screen', style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
