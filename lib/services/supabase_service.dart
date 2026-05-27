import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String _supabaseUrl = 'https://qwkdkcycwvvdcqmaxodw.supabase.co';
  static const String _anonKey     = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF3a2RrY3ljd3Z2ZGNxbWF4b2R3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3NTYxNTgsImV4cCI6MjA5NTMzMjE1OH0.BYOwYUxy3GwrkUvXEp0ekZomU8KLCv5QD9knBP6m5as';

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      // On web hot reload Supabase may already be initialized — check first
      Supabase.instance.client;
      _initialized = true;
      return;
    } catch (_) {
      // Not yet initialized, proceed normally
    }
    await Supabase.initialize(
      url:     _supabaseUrl,
      anonKey: _anonKey,
    );
    _initialized = true;
  }

  static SupabaseClient get client => Supabase.instance.client;
  static User? get currentUser => client.auth.currentUser;
  static String? get userId => currentUser?.id;
}
