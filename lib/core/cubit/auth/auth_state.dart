import '../../models/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
}


class AuthState {

  final AuthStatus status;
  final UserModel? profile;
  final String? message;


  const AuthState({
    required this.status,
    this.profile,
    this.message,
  });


  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
    );
  }


  AuthState copyWith({
    AuthStatus? status,
    UserModel? profile,
    String? message,
  }) {

    return AuthState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      message: message ?? this.message,
    );

  }

}