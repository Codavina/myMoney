import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
import 'package:my_money/core/cubit/fund/fund_cubit.dart';
import 'package:my_money/core/repositories/sync_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/cubit/auth/auth_cubit.dart';
import 'core/database/app_database.dart';
import 'core/repositories/auth_repository.dart';
import 'core/repositories/currency_repository.dart';
import 'core/repositories/fund_repository.dart';
import 'core/repositories/transaction_repository.dart';
import 'core/repositories/user_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth_screen/auth_gate_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPreferences.getInstance();
  final database = AppDatabase.instance;
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );



  // Create shared repository instances.
  // They are passed to Cubits instead of being created inside widgets.
  final currencyRepository = CurrencyRepository();
  final fundRepository = FundRepository();
  final transactionRepository = TransactionRepository();
  final authRepository = AuthRepository();
  final userRepository = UserRepository();


  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('fr'),
      startLocale: const Locale('fr'),
      child: MyMoneyApp(
        currencyRepository: currencyRepository,
        fundRepository: fundRepository,
        transactionRepository: transactionRepository,
        authRepository: authRepository,
        userRepository: userRepository,
        syncRepository: SyncRepository(
          userRepository: userRepository,
          currencyRepository: currencyRepository,
          fundRepository: fundRepository,
          transactionRepository: transactionRepository,
          database: database,
        ),
      ),
    ),
  );
}

class MyMoneyApp extends StatelessWidget {
  const MyMoneyApp({
    super.key,
    required this.currencyRepository,
    required this.fundRepository,
    required this.transactionRepository,
    required this.authRepository,
    required this.userRepository,
    required this.syncRepository,
  });

  final CurrencyRepository currencyRepository;
  final FundRepository fundRepository;
  final TransactionRepository transactionRepository;
  final AuthRepository authRepository;
  final UserRepository userRepository;

  final SyncRepository syncRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: currencyRepository),
        RepositoryProvider.value(value: fundRepository),
        RepositoryProvider.value(value: transactionRepository),
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: syncRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CurrencyCubit(currencyRepository)..getAll(),
          ),
          BlocProvider(create: (_) => FundCubit(fundRepository)),

          BlocProvider(
            create: (_) =>
                AuthCubit(authRepository, userRepository)..checkSession(),
          ),

          BlocProvider(create: (_) => ThemeCubit()..loadTheme()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'My Money',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,

              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,

              home: const AuthGateScreen(),
            );
          },
        ),
      ),
    );
  }
}
