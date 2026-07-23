class UserModel {
  final int? userId;
  final String authId;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;

  const UserModel({
    this.userId,
    required this.authId,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  bool get isViewer => role == 'viewer';
}