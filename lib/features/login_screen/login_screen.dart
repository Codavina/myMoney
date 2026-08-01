import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/constants/app_assets.dart';
import 'package:my_money/core/cubit/auth/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/cubit/auth/auth_cubit.dart';
import '../../core/theme/app_color_extension.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _login() {
    debugPrint('LOGIN 1');

    if (!_formKey.currentState!.validate()) {
      debugPrint('LOGIN 2 - INVALID');

      return;
    }

    debugPrint('LOGIN 3');
    FocusScope.of(context).unfocus();

    debugPrint('LOGIN 4');

    final cubit = context.read<AuthCubit>();

    debugPrint('LOGIN 5 - Cubit = $cubit');

    cubit.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    debugPrint('LOGIN 6');
  }

  Future<void> _loadLastEmail() async {
    final prefs = await SharedPreferences.getInstance();

    _emailController.text = prefs.getString('last_email') ?? '';
  }

  @override
  void initState() {
    super.initState();
    _loadLastEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
        previous.message != current.message &&
            current.message != null,
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message ?? 'Unable to sign in.',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.signingIn;
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 280,
                            maxHeight: 180,
                          ),
                          child: Image.asset(
                            AppAssets.logo,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 24),


                        const Text(
                          'Sign in to continue',

                        ),

                        const SizedBox(height: 30),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [
                            AutofillHints.email,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required.';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [
                            AutofillHints.password,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password is required.';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _login(),
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: context.appColors.primary,),
                            onPressed: isLoading ? null : _login,
                            child: isLoading
                                ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                                : const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
