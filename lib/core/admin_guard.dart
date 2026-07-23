// import 'package:my_money/core/repositories/auth_repository.dart';
//
// import 'errors/app_exception.dart';
//
// class AdminGuard {
//   final AuthRepository authRepository;
//
//   AdminGuard(this.authRepository);
//
//   Future<void> check() async {
//
//     final profile =
//     await authRepository.currentSession();
//
//     if (profile == null) {
//       throw const AppException(
//         'User not authenticated.',
//       );
//     }
//
//     if (profile.role != 'admin') {
//       throw const AppException(
//         'You do not have permission to perform this action.',
//       );
//     }
//   }
// }