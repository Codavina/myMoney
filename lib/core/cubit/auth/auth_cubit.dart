import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_money/core/extensions/profile_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import '../../session/current_user.dart';
import '../../session/selected_user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthCubit(this._authRepository, this._userRepository)
    : super(AuthState.initial());

  Future<void> checkSession() async {
    log("========== checkSession() ==========");

    emit(state.copyWith(status: AuthStatus.signingIn));

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

      final localUser = await _userRepository.getByAuthId(user.id);

      if (localUser == null) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            message: 'Local user not found',
          ),
        );
        return;
      }

      CurrentUser.value = localUser;

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          profile: localUser,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, message: e.toString()));
    }
  }

  Future<void> signIn({required String email, required String password}) async {

    emit(state.copyWith(status: AuthStatus.signingIn, clearMessage: true));

    try {
      final hasInternet = await InternetConnection().hasInternetAccess;

      if (!hasInternet) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            message: 'No internet connection. The first login requires an internet connection.',
          ),
        );
        return;
      }
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

      UserModel? localUser = await _userRepository.getByAuthId(profile.authId);

      if (profile.isAdmin) {

        // Admin موجود محلياً؟
        if (localUser == null) {
          await _userRepository.insert(profile);
          localUser = await _userRepository.getByAuthId(profile.authId);
        }

        // مزامنة جميع الـ viewers
        final users = await _authRepository.getAllProfiles();

        for (final user in users) {
          await _userRepository.upsert(user);
        }

      } else {

        // Viewer لا يقوم بأي Insert
        if (localUser == null) {
          throw Exception(
            'Your account is not available on this device. '
                'Please ask the administrator to synchronize users first.',
          );
        }
      }

      CurrentUser.value = localUser;

      if (localUser!.isAdmin) {
        final users = await _authRepository.getAllProfiles();

        for (final user in users) {
          await _userRepository.upsert(user);
        }
      }
      final localUsers = await _userRepository.getAll();

      log('SQLite Users: ${localUsers.length}');

      emit(
        state.copyWith(status: AuthStatus.authenticated, profile: localUser),
      );
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
    emit(state.copyWith(status: AuthStatus.signingOut));

    try {
      await _authRepository.signOut();

      CurrentUser.value = null;
      SelectedUser.value = null;

      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearProfile: true,
          clearMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}
