import 'package:my_money/core/constants/app_assets.dart';

class CurrencyInfo {
  final String code;
  final String name;
  final String flag;

  const CurrencyInfo({
    required this.code,
    required this.name,
    required this.flag,
  });
}

 const Map<String, CurrencyInfo> currenciesInfo = {
  'DZD': CurrencyInfo(
    code: 'DZD',
    name: 'Algerian Dinar',
    flag: AppAssets.algerianFlag,
  ),

  'USD': CurrencyInfo(
    code: 'USD',
    name: 'US Dollar',
    flag: AppAssets.usFlag
  ),

  'EUR': CurrencyInfo(
    code: 'EUR',
    name: 'Euro',
    flag: AppAssets.eurFlag,
  ),

   'AED': CurrencyInfo(
     code: 'AED',
     name: 'UAE Dirham',
     flag: AppAssets.uaeFlag,
   ),

   'TND': CurrencyInfo(
     code: 'TND',
     name: 'Tunisian Dinar',
     flag: AppAssets.tunisiaFlag,
   ),

   'TRY': CurrencyInfo(
     code: 'TRY',
     name: 'Turkish Lira',
     flag: AppAssets.turkeyFlag,
   ),

   'SAR': CurrencyInfo(
     code: 'SAR',
     name: 'Saudi Riyal',
     flag: AppAssets.saudiArabiaFlag,
   ),


};

const unknownCurrency = CurrencyInfo(
  code: '',
  name: 'Unknown Currency',
  flag: AppAssets.unknownCurrency,
);