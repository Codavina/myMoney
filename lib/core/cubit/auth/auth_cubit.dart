import 'package:flutter/material.dart';
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
    debugPrint("========== checkSession() ==========");

    emit(state.copyWith(status: AuthStatus.signingIn));

    try {
      final session = Supabase.instance.client.auth.currentSession;
      debugPrint("Session: $session");

      if (session == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));

        return;
      }

      final user = Supabase.instance.client.auth.currentUser;
      debugPrint("User: ${user?.id}");

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
    debugPrint('========== SIGN IN START ==========');

    emit(
      state.copyWith(
        status: AuthStatus.signingIn,
        clearMessage: true,
      ),
    );

    try {
      debugPrint('STEP 1 - Checking internet...');

      final hasInternet =
      await InternetConnection().hasInternetAccess;

      debugPrint('Internet = $hasInternet');

      if (!hasInternet) {
        debugPrint('STEP 2 - No internet');

        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            message:
            'No internet connection. The first login requires an internet connection.',
          ),
        );

        return;
      }

      debugPrint('STEP 3 - Signing in with Supabase');

      await _authRepository.signIn(
        email: email,
        password: password,
      );

      debugPrint('STEP 4 - Sign in succeeded');

      final authUser =
          Supabase.instance.client.auth.currentUser;

      debugPrint('STEP 5 - Current user = ${authUser?.id}');

      if (authUser == null) {
        throw Exception('Authenticated user not found.');
      }

      debugPrint('STEP 6 - Loading profile');

      final profile =
      await _authRepository.getProfile(authUser.id);

      debugPrint('Profile = $profile');

      if (profile == null) {
        throw Exception('User profile not found.');
      }

      debugPrint('STEP 7 - Loading local user');

      UserModel? localUser =
      await _userRepository.getByAuthId(profile.authId);

      debugPrint('Local user = $localUser');

      if (localUser == null) {
        debugPrint('STEP 8 - First login -> insert local user');

        await _userRepository.insert(profile);

        localUser =
        await _userRepository.getByAuthId(profile.authId);

        debugPrint('Inserted local user = $localUser');
      }

      if (localUser!.isAdmin) {
        debugPrint('STEP 9 - Loading all viewer accounts');

        final users =
        await _authRepository.getAllProfiles();

        debugPrint('SUPABASE USERS COUNT = ${users.length}');

        for (final user in users) {
          debugPrint('UPSERT ${user.fullName}');
          await _userRepository.upsert(user);
        }
      }

      debugPrint('STEP 10 - Save CurrentUser');

      CurrentUser.value = localUser;

      debugPrint('STEP 11 - Emit authenticated');

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          profile: localUser,
        ),
      );

      debugPrint('========== SIGN IN SUCCESS ==========');
    } catch (e, s) {
      debugPrint('========== SIGN IN FAILED ==========');
      debugPrint(e.toString());
      debugPrint(s.toString());

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
    emit(
      state.copyWith(
        status: AuthStatus.signingOut,
      ),
    );

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
    } catch (e, s) {
      debugPrint('========== SIGN OUT ERROR ==========');
      debugPrint(e.toString());
      debugPrint(s.toString());

      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}
