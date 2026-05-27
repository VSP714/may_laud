import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    // On web hot reload Supabase may already be initialized — check first
    try {
      Supabase.instance.client;
      _initialized = true;
      return;
    } catch (_) {
      // Not yet initialized, proceed normally
    }

    await dotenv.load(fileName: ".env");

    await Supabase.initialize(
      url:     dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    _initialized = true;
  }

  static SupabaseClient get client => Supabase.instance.client;
  static User? get currentUser => client.auth.currentUser;
  static String? get userId => currentUser?.id;
}