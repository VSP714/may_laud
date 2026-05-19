import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:may_laud/providers/auth_provider.dart';
import 'package:may_laud/core/local_storage.dart';

void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;

    setUp(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      // Initialize LocalStorage
      await LocalStorage.init();
      // Clear any stored data before each test
      LocalStorage.clearAll();
      authProvider = AuthProvider();
    });

    tearDown(() {
      authProvider.dispose();
    });

    test('Initial state should be unauthenticated', () {
      expect(authProvider.state.isAuthenticated, false);
      expect(authProvider.state.isLoading, false);
      expect(authProvider.state.user, null);
      expect(authProvider.state.error, null);
    });

    test('Login with valid credentials should authenticate user', () async {
      // Arrange
      const email = 'test@milaor.gov.ph';
      const password = 'password123';

      // Act
      await authProvider.login(email, password);

      // Assert
      expect(authProvider.state.isAuthenticated, true);
      expect(authProvider.state.user, isNotNull);
      expect(authProvider.state.user?.email, email);
      expect(authProvider.state.user?.name, contains('Test User'));
      expect(authProvider.state.error, null);
    });

    test('Login with invalid credentials should set error', () async {
      // Arrange
      const email = 'invalid@example.com';
      const password = 'wrongpassword';

      // Act
      await authProvider.login(email, password);

      // Assert
      expect(authProvider.state.isAuthenticated, false);
      expect(authProvider.state.user, null);
      expect(authProvider.state.error, isNotNull);
      expect(authProvider.state.error, contains('Invalid credentials'));
    });

    test('Register should create new user and authenticate', () async {
      // Arrange
      const name = 'New User';
      const email = 'newuser@milaor.gov.ph';
      const password = 'newpassword123';
      const phone = '09123456789';
      const address = 'Milaor, Camarines Sur';

      // Act
      await authProvider.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
      );

      // Assert
      expect(authProvider.state.isAuthenticated, true);
      expect(authProvider.state.user, isNotNull);
      expect(authProvider.state.user?.name, name);
      expect(authProvider.state.user?.email, email);
      expect(authProvider.state.user?.phone, phone);
      expect(authProvider.state.user?.address, address);
      expect(authProvider.state.error, null);
    });

    test('Logout should clear authentication state', () async {
      // Arrange - First login
      await authProvider.login('test@milaor.gov.ph', 'password123');
      expect(authProvider.state.isAuthenticated, true);

      // Act
      await authProvider.logout();

      // Assert
      expect(authProvider.state.isAuthenticated, false);
      expect(authProvider.state.user, null);
      expect(authProvider.state.error, null);
    });

    test('Update profile should modify user data', () async {
      // Arrange - First login
      await authProvider.login('test@milaor.gov.ph', 'password123');
      final originalUser = authProvider.state.user;

      // Act
      await authProvider.updateProfile(
        name: 'Updated Name',
        phone: '09987654321',
        address: 'New Address, Milaor',
      );

      // Assert
      expect(authProvider.state.user?.name, 'Updated Name');
      expect(authProvider.state.user?.phone, '09987654321');
      expect(authProvider.state.user?.address, 'New Address, Milaor');
      // Email should remain unchanged
      expect(authProvider.state.user?.email, originalUser?.email);
      expect(authProvider.state.error, null);
    });

    test('Check auth status should restore user from storage', () async {
      // Arrange - Login and store user
      await authProvider.login('test@milaor.gov.ph', 'password123');
      final originalUser = authProvider.state.user;
      await authProvider.logout();

      // Create new provider which should check storage
      authProvider.dispose();
      authProvider = AuthProvider();

      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - Should be authenticated from storage
      expect(authProvider.state.isAuthenticated, true);
      expect(authProvider.state.user?.email, originalUser?.email);
    });
  });

  group('User Model Tests', () {
    test('User.fromJson should parse valid JSON', () {
      // Arrange
      final json = {
        'id': 'user123',
        'name': 'John Doe',
        'email': 'john@milaor.gov.ph',
        'phone': '09123456789',
        'profileImage': 'https://example.com/avatar.jpg',
        'address': 'Milaor, Camarines Sur',
        'createdAt': '2024-01-01T00:00:00.000Z',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, 'user123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@milaor.gov.ph');
      expect(user.phone, '09123456789');
      expect(user.profileImage, 'https://example.com/avatar.jpg');
      expect(user.address, 'Milaor, Camarines Sur');
      expect(user.createdAt, DateTime.utc(2024, 1, 1));
    });

    test('User.toJson should serialize correctly', () {
      // Arrange
      final user = User(
        id: 'user123',
        name: 'John Doe',
        email: 'john@milaor.gov.ph',
        phone: '09123456789',
        profileImage: 'https://example.com/avatar.jpg',
        address: 'Milaor, Camarines Sur',
        createdAt: DateTime.utc(2024, 1, 1),
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], 'user123');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@milaor.gov.ph');
      expect(json['phone'], '09123456789');
      expect(json['profileImage'], 'https://example.com/avatar.jpg');
      expect(json['address'], 'Milaor, Camarines Sur');
      expect(json['createdAt'], '2024-01-01T00:00:00.000Z');
    });
  });
}
