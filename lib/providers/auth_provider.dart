import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;
import 'package:may_laud/core/local_storage.dart';
import 'package:may_laud/services/supabase_service.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? address;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.address,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id:           json['id'] ?? '',
      name:         json['name'] ?? '',
      email:        json['email'] ?? '',
      phone:        json['phone'],
      profileImage: json['avatar_url'],
      address:      json['address'],
      createdAt:    json['created_at'] != null
                      ? DateTime.parse(json['created_at'])
                      : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':         id,
    'name':       name,
    'email':      email,
    'phone':      phone,
    'avatar_url': profileImage,
    'address':    address,
    'created_at': createdAt?.toIso8601String(),
  };
}

class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;
  final bool isAuthenticated;
  final bool isGuest;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isAuthenticated = false,
    this.isGuest = false,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
    bool? isAuthenticated,
    bool? isGuest,
  }) {
    return AuthState(
      isLoading:       isLoading       ?? this.isLoading,
      user:            user            ?? this.user,
      error:           error           ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest:         isGuest         ?? this.isGuest,
    );
  }
}

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider() : super(const AuthState()) {
    _checkAuthStatus();
  }

  SupabaseClient get _client => SupabaseService.client;

  Future<void> _checkAuthStatus() async {
    try {
      final session = _client.auth.currentSession;
      if (session != null) {
        await _loadProfile(session.user.id, session.user.email ?? '');
      }
    } catch (e) {
      // Supabase not yet initialized (e.g. test environment) — stay unauthenticated
      debugPrint('[AuthProvider] _checkAuthStatus skipped: $e');
    }
  }

  Future<void> _loadProfile(String uid, String email) async {
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', uid)
          .single();

      final user = User.fromJson({...data, 'email': email});
      state = state.copyWith(user: user, isAuthenticated: true, isLoading: false);

      await LocalStorage.saveUserData(
        userId:    user.id,
        userName:  user.name,
        userEmail: user.email,
      );
    } catch (_) {
      state = state.copyWith(isAuthenticated: false, isLoading: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _client.auth.signInWithPassword(
        email:    email,
        password: password,
      );
      if (response.user != null) {
        await _loadProfile(response.user!.id, email);
      }
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Login failed. Please try again.');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _client.auth.signUp(
        email:    email,
        password: password,
        data: {'name': name, 'phone': phone},
        emailRedirectTo: null,
      );

      if (response.user != null) {
        await LocalStorage.saveUserData(
          userId:    response.user!.id,
          userName:  name,
          userEmail: email,
        );
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: 'Registration failed. Please try again.');
      }
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Registration failed. Please try again.');
    }
  }

  Future<void> completeRegistration({
    required String name,
    required String phone,
    required String address,
  }) async {
    final uid = SupabaseService.userId;
    if (uid == null) return;
    try {
      await _client.from('profiles').update({
        'name':    name,
        'phone':   phone,
        'address': address,
      }).eq('id', uid);
    } catch (_) {}
  }

  Future<void> loginAsGuest() async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 400));
    await LocalStorage.clearAll();
    state = state.copyWith(
      isLoading: false,
      user: User(
        id:    'guest_${DateTime.now().millisecondsSinceEpoch}',
        name:  'Guest User',
        email: '',
      ),
      isAuthenticated: true,
      isGuest: true,
    );
  }

 Future<void> logout() async {
  state = state.copyWith(isLoading: true);
  if (!state.isGuest) {
    await _client.auth.signOut();
  }
  await LocalStorage.clearAll();
  state = const AuthState(isLoading: false);
}

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? profileImage,
  }) async {
    if (state.user == null || state.isGuest) return;

    final updates = <String, dynamic>{};
    if (name         != null) updates['name']       = name;
    if (phone        != null) updates['phone']      = phone;
    if (address      != null) updates['address']    = address;
    if (profileImage != null) updates['avatar_url'] = profileImage;

    await _client.from('profiles').update(updates).eq('id', state.user!.id);

    final updated = User(
      id:           state.user!.id,
      name:         name         ?? state.user!.name,
      email:        state.user!.email,
      phone:        phone        ?? state.user!.phone,
      address:      address      ?? state.user!.address,
      profileImage: profileImage ?? state.user!.profileImage,
      createdAt:    state.user!.createdAt,
    );

    await LocalStorage.saveUserData(
      userId:    updated.id,
      userName:  updated.name,
      userEmail: updated.email,
    );

    state = state.copyWith(user: updated);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  void clearError() => state = state.copyWith(error: null);
}

final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
  (ref) => AuthProvider(),
);