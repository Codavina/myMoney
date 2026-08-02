import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/user/user_state.dart';
import '../../repositories/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._repository)
      : super(const UserLoading());

  final UserRepository _repository;

  Future<void> getAllUsers() async {
    emit(const UserLoading());

    try {
      final users = await _repository.getAll();

      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}