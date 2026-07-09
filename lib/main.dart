import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
import 'package:my_money/core/cubit/fund/fund_cubit.dart';
import 'package:my_money/core/cubit/transaction/transaction_cubit.dart';
import 'package:my_money/features/fund_screen/fund_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'core/database/app_database.dart';
import 'core/repositories/currency_repository.dart';
import 'core/repositories/fund_repository.dart';
import 'core/repositories/transaction_repository.dart';
import 'core/theme/app_theme.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  //sqflite_common_ffi package for run app on windows
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await AppDatabase.instance.database;

  // Create shared repository instances.
  // They are passed to Cubits instead of being created inside widgets.
  final currencyRepository = CurrencyRepository();
  final fundRepository = FundRepository();
  final transactionRepository = TransactionRepository();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyMoneyApp(
        currencyRepository: currencyRepository,
        fundRepository: fundRepository,
        transactionRepository: transactionRepository,
      ), // Wrap your app
    ),
  );
}

class MyMoneyApp extends StatelessWidget {
  const MyMoneyApp({
    super.key,
    required this.currencyRepository,
    required this.fundRepository,
    required this.transactionRepository,
  });

  final CurrencyRepository currencyRepository;
  final FundRepository fundRepository;
  final TransactionRepository transactionRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CurrencyCubit(currencyRepository)..getAll()),
        BlocProvider(create: (context) => FundCubit(fundRepository)..getAll()),
        BlocProvider(
          create: (context) => TransactionCubit(transactionRepository)..getAll(),
        ),
      ],
      child: MaterialApp(
        title: 'My Money App',

        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const FundScreen(),
      ),
    );
  }
}
