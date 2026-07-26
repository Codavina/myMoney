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

  /// Current logged in user.
  /// null when the user is not authenticated.
  final UserModel? profile;

  /// Error message when status == failure.
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
    bool clearProfile = false,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      profile: clearProfile ? null : (profile ?? this.profile),
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  String toString() {
    return 'AuthState('
        'status: $status, '
        'profile: $profile, '
        'message: $message'
        ')';
  }
}