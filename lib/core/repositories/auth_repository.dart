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

  Future<List<UserModel>> getAllProfiles() async {
    final response = await Supabase.instance.client
        .from('profiles')
        .select('id,user_id, full_name, email, phone, role')
        .eq('role', 'viewer')
        .order('full_name');

    return (response as List)
        .map((e) => UserModel.fromSupabase(e))
        .toList();
  }
}