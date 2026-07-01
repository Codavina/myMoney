import 'package:intl/intl.dart';

class AppFormatter {

  //12500.00 => 12.500,00
  static final money =NumberFormat('#,##0.00', 'de_DE');

  // Jul13, 2026 => 13.07.26
  static final date =DateFormat('dd.MM.yy');





}


