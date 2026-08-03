import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_money/core/extensions/profile_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    emit(state.copyWith(status: AuthStatus.signingIn));

    try {
      final session = Supabase.instance.client.auth.currentSession;


      if (session == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));

        return;
      }

      final user = Supabase.instance.client.auth.currentUser;


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

    emit(
      state.copyWith(
        status: AuthStatus.signingIn,
        clearMessage: true,
      ),
    );

    try {

      final hasInternet =
      await InternetConnection().hasInternetAccess;

      if (!hasInternet) {

        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            message:
            'No internet connection. The first login requires an internet connection.',
          ),
        );

        return;
      }

      await _authRepository.signIn(
        email: email,
        password: password,
      );

      final authUser =
          Supabase.instance.client.auth.currentUser;

      if (authUser == null) {
        throw Exception('Authenticated user not found.');
      }

      final profile =
      await _authRepository.getProfile(authUser.id);

      if (profile == null) {
        throw Exception('User profile not found.');
      }

      UserModel? localUser =
      await _userRepository.getByAuthId(profile.authId);

      if (localUser == null) {

        await _userRepository.insert(profile);

        localUser =
        await _userRepository.getByAuthId(profile.authId);

      }

      if (localUser!.isAdmin) {

        final users =
        await _authRepository.getAllProfiles();

              for (final user in users) {

          await _userRepository.upsert(user);
        }
      }

      CurrentUser.value = localUser;

           final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'last_email',
        email,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          profile: localUser,
        ),
      );


    } catch (e) {
      String message = 'Unable to sign in.';

      if (e is AuthApiException &&
          e.code == 'invalid_credentials') {
        message = 'Invalid email or password.';
      }

      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          message: message,
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
