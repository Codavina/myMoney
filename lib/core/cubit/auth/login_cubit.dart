import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/repositories/auth_repository.dart';

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

      final user = response.user;

      if (user == null) {
        emit(const LoginError('Login failed.'));
        return;
      }

      // انتهت مهمتنا في هذه المرحلة
      emit(const LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}