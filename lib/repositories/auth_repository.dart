import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _supabase = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password must not be empty.');
      }
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      // Do NOT insert into users table here; wait until after email confirmation and first login
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      print("Signup error: $e");
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // After successful login, ensure user row exists
      if (response.user != null) {
        final profile =
            await _supabase
                .from('users')
                .select()
                .eq('id', response.user!.id)
                .maybeSingle();
        if (profile == null) {
          await _supabase.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'created_at': DateTime.now().toUtc().toIso8601String(),
            'nickname': '',
            'full_name': '',
            'company': '',
          });
        }
      }
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      print("Error: $e");
      throw Exception('An unknown error occurred during sign in.');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}
