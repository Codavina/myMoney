import '../models/user_model.dart';

extension ProfileExtension on UserModel {

  bool get isAdmin => role == 'admin';

  bool get isViewer => role == 'viewer';

}