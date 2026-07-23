class UserModel {
  final int? userId;
  final String authId;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final DateTime? createdAt;

  const UserModel({
    this.userId,
    required this.authId,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    this.createdAt,
  });

  /// SQLite Map -> UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] as int?,
      authId: map['auth_id'] as String,
      fullName: map['full_name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
      role: map['role'] as String,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// UserModel -> SQLite Map
  Map<String, dynamic> toMap() {
    return {
      if (userId != null) 'user_id': userId,
      'auth_id': authId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,

      // عند الإدراج لأول مرة نترك SQLite يملأ created_at
      if (userId != null && createdAt != null)
        'created_at': createdAt!.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? userId,
    String? authId,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      authId: authId ?? this.authId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return '''
UserModel(
  userId: $userId,
  authId: $authId,
  fullName: $fullName,
  email: $email,
  phone: $phone,
  role: $role,
  createdAt: $createdAt
)
''';
  }
}