import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key,this.message = 'Loading...'});
  final String message;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            const CircularProgressIndicator(),

            const SizedBox(height: 20),

            Text(message),

          ],

        ),

      ),

    );

  }

}