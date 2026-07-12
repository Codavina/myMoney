import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_enums.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(EnNavigationPages.home));

  void changePage(EnNavigationPages page) {
    emit(NavigationState(page));
  }
}