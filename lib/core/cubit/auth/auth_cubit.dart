import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import '../../session/current_user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthCubit(this._authRepository, this._userRepository)
    : super(AuthState.initial());

  Future<void> checkSession() async {
    log("========== checkSession() ==========");

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final session = Supabase.instance.client.auth.currentSession;
      log("Session: $session");

      if (session == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));

        return;
      }

      final user = Supabase.instance.client.auth.currentUser;
      log("User: ${user?.id}");

      if (user == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));

        return;
      }
      final profile = await _authRepository.getCachedUser();

      if (profile == null) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            message: 'Cached user not found',
          ),
        );
        return;
      }

      CurrentUser.value = profile;

      emit(state.copyWith(status: AuthStatus.authenticated, profile: profile));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, message: e.toString()));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));

    try {
      // Login
      await _authRepository.signIn(email: email, password: password);

      log('1- Login success');

      final authUser = Supabase.instance.client.auth.currentUser;

      if (authUser == null) {
        throw Exception('User not found.');
      }

      log('2- User ID: ${authUser.id}');

      // Load profile from Supabase
      final profile = await _authRepository.getProfile(authUser.id);

      if (profile == null) {
        throw Exception('Profile not found.');
      }

      log('3- Profile loaded');

      // Current user
      CurrentUser.value = profile;

      log('4- CurrentUser filled');

      // Cache locally
      await _authRepository.cacheUser(profile);

      log('5- User cached');

      emit(state.copyWith(status: AuthStatus.authenticated, profile: profile));
    } catch (e, s) {
      log("========== SIGN IN ERROR ==========");
      log(e.toString());
      log(s.toString());
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: e.toString(),
          clearProfile: true,
        ),
      );
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));

    try {
      await _authRepository.signOut();
      await _authRepository.clearCachedUser();
      CurrentUser.value = null;

      emit(
        state.copyWith(status: AuthStatus.unauthenticated, clearProfile: true),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, message: e.toString()));
    }
  }
}
