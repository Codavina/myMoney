import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Sign in with email & password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Returns the current active session if available
  Session? currentSession() {
    return _client.auth.currentSession;
  }

  Future<void> cacheUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('auth_id', user.authId);
    await prefs.setString('full_name', user.fullName);
    await prefs.setString('email', user.email);
    await prefs.setString('phone', user.phone ?? '');
    await prefs.setString('role', user.role);
  }

  Future<void> clearCachedUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('auth_id');
    await prefs.remove('full_name');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('role');
  }

  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();

    final authId = prefs.getString('auth_id');

    if (authId == null) {
      return null;
    }

    return UserModel(
      userId: null,
      authId: authId,
      fullName: prefs.getString('full_name') ?? '',
      email: prefs.getString('email') ?? '',
      phone: prefs.getString('phone'),
      role: prefs.getString('role') ?? 'viewer',
      createdAt: DateTime.now(),
    );
  }

  Future<UserModel?> getProfile(String authId) async {
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', authId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserModel.fromSupabase(response);
  }
}