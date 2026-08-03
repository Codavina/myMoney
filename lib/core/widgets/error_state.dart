import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("Error state Screen");
    return const Scaffold(
      body: Center(
        child: Text('Error State Screen'),
      ),
    );
  }
}
