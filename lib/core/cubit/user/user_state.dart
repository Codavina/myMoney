import '../../models/user_model.dart';

abstract class UserState {
  const UserState();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final List<UserModel> users;

  const UserLoaded(this.users);
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);
}