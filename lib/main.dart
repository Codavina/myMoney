import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
import 'package:my_money/core/cubit/fund/fund_cubit.dart';
import 'package:my_money/features/login_screen/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/cubit/auth/auth_cubit.dart';
import 'core/cubit/login/login_cubit.dart';
import 'core/repositories/auth_repository.dart';
import 'core/repositories/currency_repository.dart';
import 'core/repositories/fund_repository.dart';
import 'core/repositories/transaction_repository.dart';
import 'core/repositories/user_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/auth_screen/auth_gate_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );


  debugPrint('Supabase initialized successfully.');

  // Create shared repository instances.
  // They are passed to Cubits instead of being created inside widgets.
  final currencyRepository = CurrencyRepository();
  final fundRepository = FundRepository();
  final transactionRepository = TransactionRepository();
  final authRepository = AuthRepository();
  final userRepository = UserRepository();


  runApp(
    MyMoneyApp(
      currencyRepository: currencyRepository,
      fundRepository: fundRepository,
      transactionRepository: transactionRepository,
      authRepository: authRepository,
      userRepository: userRepository,
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
  });

  final CurrencyRepository currencyRepository;
  final FundRepository fundRepository;
  final TransactionRepository transactionRepository;
  final AuthRepository authRepository;
  final UserRepository userRepository ;


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
        ],
        child: MultiBlocProvider(
          providers: [

            BlocProvider(
              create: (_) => CurrencyCubit(currencyRepository)..getAll(),
            ),
            BlocProvider(
              create: (_) => FundCubit(fundRepository)..getAllActive(),
            ),
            BlocProvider(
              create: (_) =>LoginCubit(authRepository),
            ),
            BlocProvider(
              create: (_) => AuthCubit(userRepository)
                ..checkSession(),
            ),
          ],
      child: MaterialApp(
        title: 'My Money App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const AuthGateScreen(),
      ),),
    );
  }
}
