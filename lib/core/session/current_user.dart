import '../models/user_model.dart';


class CurrentUser {
  CurrentUser._();

  static UserModel? value;

  static bool get isLoggedIn => value != null;

  static void clear() {
    value = null;
  }
}