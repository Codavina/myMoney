import 'package:flutter/material.dart';

class CustomAdminCard extends StatelessWidget {
  const CustomAdminCard({
    super.key,
    required this.title,
    required this.icon,
    required this.borderColor,
    required this.onTap,

  });

  final String title;
  final IconData icon;
  final Color borderColor;
  final Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: const Color(0xffF1F5F9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36,color: Colors.grey.shade700,),
              const SizedBox(height: 10),
              Text(
                title,
                style:  TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}