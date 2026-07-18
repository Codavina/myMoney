import 'package:flutter/material.dart';

class DialogTitleDecoration extends StatelessWidget {
  const DialogTitleDecoration({
    super.key,

    required this.dialogTitle, required this.color,
  });


  final Widget dialogTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
        color:color,//
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        border: Border.all(color: Colors.white,width: 0.4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: dialogTitle,
      ),
    );
  }
}