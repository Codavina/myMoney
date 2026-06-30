import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatter {
  static final money =
  NumberFormat('#,##0.00', 'de_DE');


  static final List<TextInputFormatter> inputFormatters=[
    FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}$')),
  ];


}


