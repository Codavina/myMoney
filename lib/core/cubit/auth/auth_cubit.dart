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

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    log('========== SIGN IN START ==========');

    emit(
      state.copyWith(
        status: AuthStatus.signingIn,
        clearMessage: true,
      ),
    );

    try {
      log('STEP 1 - Checking internet...');

      final hasInternet =
      await InternetConnection().hasInternetAccess;

      log('Internet = $hasInternet');

      if (!hasInternet) {
        log('STEP 2 - No internet');

        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            message:
            'No internet connection. The first login requires an internet connection.',
          ),
        );

        return;
      }

      log('STEP 3 - Signing in with Supabase');

      await _authRepository.signIn(
        email: email,
        password: password,
      );

      log('STEP 4 - Sign in succeeded');

      final authUser =
          Supabase.instance.client.auth.currentUser;

      log('STEP 5 - Current user = ${authUser?.id}');

      if (authUser == null) {
        throw Exception('Authenticated user not found.');
      }

      log('STEP 6 - Loading profile');

      final profile =
      await _authRepository.getProfile(authUser.id);

      log('Profile = $profile');

      if (profile == null) {
        throw Exception('User profile not found.');
      }

      log('STEP 7 - Loading local user');

      UserModel? localUser =
      await _userRepository.getByAuthId(profile.authId);

      log('Local user = $localUser');

      if (localUser == null) {
        log('STEP 8 - First login -> insert local user');

        await _userRepository.insert(profile);

        localUser =
        await _userRepository.getByAuthId(profile.authId);

        log('Inserted local user = $localUser');
      }

      if (localUser!.isAdmin) {
        log('STEP 9 - Loading all viewer accounts');

        final users =
        await _authRepository.getAllProfiles();

        log('SUPABASE USERS COUNT = ${users.length}');

        for (final user in users) {
          log('UPSERT ${user.fullName}');
          await _userRepository.upsert(user);
        }
      }

      log('STEP 10 - Save CurrentUser');

      CurrentUser.value = localUser;

      log('STEP 11 - Emit authenticated');

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          profile: localUser,
        ),
      );

      log('========== SIGN IN SUCCESS ==========');
    } catch (e, s) {
      log('========== SIGN IN FAILED ==========');
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
