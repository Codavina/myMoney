import 'package:easy_localization/easy_localization.dart';
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

final Map<String, CurrencyInfo> currenciesInfo = {
  'DZD': CurrencyInfo(
    code: 'DZD',
    name: 'algerian_dinar'.tr(),
    flag: AppAssets.algerianFlag,
    symbol: 'DA',
  ),

  'USD':  CurrencyInfo(
    code: 'USD',
    name: 'us_dollar'.tr(),
    flag: AppAssets.usFlag,
    symbol: '\$',
  ),

  'EUR': const CurrencyInfo(
    code: 'EUR',
    name: 'Euro',
    flag: AppAssets.eurFlag,
    symbol: '€',
  ),

  'AED': CurrencyInfo(
    code: 'AED',
    name: 'uAE_dirham'.tr(),
    flag: AppAssets.uaeFlag,
    symbol: 'AE',
  ),

  'TND':  CurrencyInfo(
    code: 'TND',
    name: 'tunisian_dinar'.tr(),
    flag: AppAssets.tunisiaFlag,
    symbol: 'TN',
  ),

  'TRY': CurrencyInfo(
    code: 'TRY',
    name: 'turkish_lira'.tr(),
    flag: AppAssets.turkeyFlag,
    symbol: '₺',
  ),

  'SAR': CurrencyInfo(
    code: 'SAR',
    name: 'saudi_riyal'.tr(),
    flag: AppAssets.saudiArabiaFlag,
    symbol: 'SR',
  ),
};

final unknownCurrency = CurrencyInfo(
  code: '',
  name: 'unknown_currency'.tr(),
  flag: AppAssets.unknownCurrency,
  symbol: 'U',
);
