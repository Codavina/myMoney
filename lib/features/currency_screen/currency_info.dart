import 'package:my_money/core/constants/app_assets.dart';

class CurrencyInfo {
  final String code;
  final String name;
  final String flag;
  final String symbol;

  const CurrencyInfo({
    required this.code,
    required this.name,
    required this.flag,
    required this.symbol,
  });
}

const Map<String, CurrencyInfo> currenciesInfo = {
  'DZD': CurrencyInfo(
    code: 'DZD',
    name: 'Algerian Dinar',
    flag: AppAssets.algerianFlag,
    symbol: 'DA',
  ),

  'USD': CurrencyInfo(
    code: 'USD',
    name: 'US Dollar',
    flag: AppAssets.usFlag,
    symbol: '\$',
  ),

  'EUR': CurrencyInfo(
    code: 'EUR',
    name: 'Euro',
    flag: AppAssets.eurFlag,
    symbol: '€',
  ),

  'AED': CurrencyInfo(
    code: 'AED',
    name: 'UAE Dirham',
    flag: AppAssets.uaeFlag,
    symbol: 'AE',
  ),

  'TND': CurrencyInfo(
    code: 'TND',
    name: 'Tunisian Dinar',
    flag: AppAssets.tunisiaFlag,
    symbol: 'TN',
  ),

  'TRY': CurrencyInfo(
    code: 'TRY',
    name: 'Turkish Lira',
    flag: AppAssets.turkeyFlag,
    symbol: '₺',
  ),

  'SAR': CurrencyInfo(
    code: 'SAR',
    name: 'Saudi Riyal',
    flag: AppAssets.saudiArabiaFlag,
    symbol: 'SR',
  ),
};

const unknownCurrency = CurrencyInfo(
  code: '',
  name: 'Unknown Currency',
  flag: AppAssets.unknownCurrency,
  symbol: 'U',
);
