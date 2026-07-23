import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../repositories/user_repository.dart';
import '../../session/current_user.dart';
import 'auth_state.dart';



class AuthCubit extends Cubit<AuthState> {


  final UserRepository _userRepository;


  AuthCubit(this._userRepository)
      : super(AuthState.initial());



  Future<void> checkSession() async {


    emit(
      state.copyWith(
        status: AuthStatus.loading,
      ),
    );


    try {


      final session =
          Supabase.instance.client.auth.currentSession;



      if (session == null) {


        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
          ),
        );


        return;
      }



      final user =
          Supabase.instance.client.auth.currentUser;



      if (user == null) {


        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
          ),
        );


        return;
      }



      final profile =
      await _userRepository.getByAuthId(user.id);



      if (profile == null) {


        emit(
          state.copyWith(
            status: AuthStatus.failure,
            message: 'Profile not found',
          ),
        );


        return;
      }



      CurrentUser.value = profile;



      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          profile: profile,
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