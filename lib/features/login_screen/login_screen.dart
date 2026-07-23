import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/cubit/login/login_cubit.dart';
import '../../core/cubit/login/login_state.dart';
import '../../core/session/current_user.dart';

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
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    context.read<LoginCubit>().signIn(
      email: _emailController.text.trim(),
      password:  _passwordController.text,
    );
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

            body: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(CurrentUser.value?.fullName ?? 'No Current User'),
                    ),
                  );
                }

                if (state is LoginError) {
                  debugPrint("LoginError: ${state.message}");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              builder: (context, state) {

               // final isLoading = state.status == AuthStatus.loading;
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
                              const Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 72,
                              ),

                              const SizedBox(height: 24),

                              Text(
                                'Welcome Back',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Sign in to continue',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),

                              const SizedBox(height: 40),

                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
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
                                onFieldSubmitted:(_) =>_login(),
                              ),

                              const SizedBox(height: 32),

                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: FilledButton(

                                  onPressed: _login,
                                  child: const Text('Login'),
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