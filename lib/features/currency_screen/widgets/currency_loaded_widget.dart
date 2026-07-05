import 'package:flutter/material.dart';

import 'currency_listview.dart';

class CurrencyLoadedWidget extends StatelessWidget {
  const CurrencyLoadedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.12,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff1B64C3), Color(0xff408CDB)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const ListTile(
              title: Text('Total Currencies',style: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    ),),
              subtitle: Text(
                '9',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Icon(Icons.monetization_on),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Expanded(child: CurrencyListview(title: 'EUR')),
      ],
    );
  }
}
