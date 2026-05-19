import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:may_laud/core/local_storage.dart';

/// User model for authentication
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
      address: json['address'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'address': address,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

/// Authentication state
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
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

/// Authentication provider
class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider() : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated from local storage
  Future<void> _checkAuthStatus() async {
    final userData = LocalStorage.getUserData();
    final token = LocalStorage.getAuthToken();

    if (token != null &&
        userData['userId'] != null &&
        userData['userName'] != null) {
      state = state.copyWith(
        user: User(
          id: userData['userId']!,
          name: userData['userName']!,
          email: userData['userEmail'] ?? '',
        ),
        isAuthenticated: true,
      );
    }
  }

  /// Mock login with email and password
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock authentication - in real app, this would call an API
    if (email.isNotEmpty && password.isNotEmpty) {
      final mockUser = User(
        id: 'user_001',
        name: 'Juan Dela Cruz',
        email: email,
        phone: '+639123456789',
        address: 'Milaor, Camarines Sur',
        profileImage: null,
        createdAt: DateTime.now(),
      );

      // Save to local storage
      await LocalStorage.saveAuthToken(
          'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}');
      await LocalStorage.saveUserData(
        userId: mockUser.id,
        userName: mockUser.name,
        userEmail: mockUser.email,
      );

      state = state.copyWith(
        isLoading: false,
        user: mockUser,
        isAuthenticated: true,
        isGuest: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid email or password',
      );
    }
  }

  /// Login as guest user
  Future<void> loginAsGuest() async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Create a guest user
    final guestUser = User(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Guest User',
      email: 'guest@example.com',
      phone: null,
      address: null,
      profileImage: null,
      createdAt: DateTime.now(),
    );

    // Don't save guest user to local storage - guest session is temporary
    // Clear any existing auth data
    await LocalStorage.clearAll();

    state = state.copyWith(
      isLoading: false,
      user: guestUser,
      isAuthenticated: true,
      isGuest: true,
    );
  }

  /// Mock registration
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock registration
    final mockUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      address: address,
      profileImage: null,
      createdAt: DateTime.now(),
    );

    // Save to local storage
    await LocalStorage.saveAuthToken(
        'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}');
    await LocalStorage.saveUserData(
      userId: mockUser.id,
      userName: mockUser.name,
      userEmail: mockUser.email,
    );

    state = state.copyWith(
      isLoading: false,
      user: mockUser,
      isAuthenticated: true,
      isGuest: false,
    );
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    // Clear local storage
    await LocalStorage.clearAll();

    // Simulate delay
    await Future.delayed(const Duration(milliseconds: 500));

    state = const AuthState(
      isLoading: false,
      isAuthenticated: false,
      isGuest: false,
    );
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? profileImage,
  }) async {
    if (state.user == null) return;

    final updatedUser = User(
      id: state.user!.id,
      name: name ?? state.user!.name,
      email: state.user!.email,
      phone: phone ?? state.user!.phone,
      address: address ?? state.user!.address,
      profileImage: profileImage ?? state.user!.profileImage,
      createdAt: state.user!.createdAt,
    );

    // Update local storage
    await LocalStorage.saveUserData(
      userId: updatedUser.id,
      userName: updatedUser.name,
      userEmail: updatedUser.email,
    );

    state = state.copyWith(user: updatedUser);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider instance
final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
  (ref) => AuthProvider(),
);
