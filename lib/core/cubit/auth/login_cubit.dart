import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/repositories/auth_repository.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repository) : super(LoginInitial());

  final AuthRepository _repository;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      await _repository.signIn(
        email: email,
        password: password,
      );

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}