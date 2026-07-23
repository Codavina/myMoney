import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user_model.dart';
import '../../session/current_user.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;

  LoginCubit(this._repository) : super(const LoginInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());

    try {
      final response = await _repository.signIn(
        email: email,
        password: password,
      );
      print('1- Login success');
      final user = response.user;
      print('2- User ID: ${user?.id}');
      if (user == null) {
        emit(const LoginError('Login failed.'));
        return;
      }

      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (profile == null) {
        throw Exception('Profile not found');
      }
      print('3- Profile loaded');
      CurrentUser.value = UserModel(
        authId: user.id,
        fullName: profile['full_name'],
        email: user.email!,
        phone: profile['phone'],
        role: profile['role'],
      );
      print('4- CurrentUser filled');
      emit(const LoginSuccess());
    }catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());

      emit(LoginError(e.toString()));
    }
  }
}