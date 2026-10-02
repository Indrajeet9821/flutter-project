// ============================================================
// FILE: lib/services/auth_service.dart
// PURPOSE: Handles all authentication logic.
//
// Currently uses MOCK (local) authentication for testing.
// When Firebase is configured (Phase 9), you simply replace
// the method bodies with Firebase Auth calls — no other file
// needs to change.
//
// Features:
// - Login with email & password
// - Register new users
// - Send password reset email (mock)
// - Logout
// - Get current user
// - Pre-loaded demo accounts for testing
// ============================================================

import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class AuthService {
  // ─── Singleton pattern (one instance for the whole app) ───
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _initDemoAccounts();
  }

  // ─── State ───
  UserModel? _currentUser;
  final Map<String, _MockAccount> _accounts = {};
  final Uuid _uuid = const Uuid();

  /// Returns the currently logged-in user, or null
  UserModel? get currentUser => _currentUser;

  /// Returns true if a user is logged in
  bool get isLoggedIn => _currentUser != null;

  // ─── Pre-loaded Demo Accounts ───
  // These let you test all 3 roles immediately without Firebase.
  void _initDemoAccounts() {
    // Student account
    _accounts['student@ccms.com'] = _MockAccount(
      password: '123456',
      user: UserModel(
        uid: 'demo-student-001',
        name: 'Rahul Sharma',
        email: 'student@ccms.com',
        phone: '9876543210',
        role: 'student',
        department: 'Computer Science',
        studentId: 'CS2024001',
        year: '2nd Year',
      ),
    );

    // Staff account
    _accounts['staff@ccms.com'] = _MockAccount(
      password: '123456',
      user: UserModel(
        uid: 'demo-staff-001',
        name: 'Prof. Anita Desai',
        email: 'staff@ccms.com',
        phone: '9876543211',
        role: 'staff',
        department: 'Computer Science',
      ),
    );

    // Admin account
    _accounts['admin@ccms.com'] = _MockAccount(
      password: '123456',
      user: UserModel(
        uid: 'demo-admin-001',
        name: 'Dr. Vikram Singh',
        email: 'admin@ccms.com',
        phone: '9876543212',
        role: 'admin',
        department: 'Administration',
      ),
    );
  }

  // ─── Login ───
  /// Attempts to log in with email and password.
  /// Returns the UserModel on success.
  /// Throws an exception with a user-friendly message on failure.
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final normalizedEmail = email.trim().toLowerCase();

    // Check if account exists
    final account = _accounts[normalizedEmail];
    if (account == null) {
      throw Exception('No account found with this email. Please register first.');
    }

    // Check password
    if (account.password != password) {
      throw Exception('Incorrect password. Please try again.');
    }

    // Success — set current user
    _currentUser = account.user;
    return _currentUser!;
  }

  // ─── Register ───
  /// Creates a new student account.
  /// Returns the newly created UserModel.
  /// Throws an exception if the email is already registered.
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String department,
    required String studentId,
    required String year,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final normalizedEmail = email.trim().toLowerCase();

    // Check if email already exists
    if (_accounts.containsKey(normalizedEmail)) {
      throw Exception('An account with this email already exists.');
    }

    // Create new user
    final newUser = UserModel(
      uid: _uuid.v4(),
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      role: 'student', // New registrations are always students
      department: department,
      studentId: studentId.trim(),
      year: year,
    );

    // Save to mock database
    _accounts[normalizedEmail] = _MockAccount(
      password: password,
      user: newUser,
    );

    // Auto-login after registration
    _currentUser = newUser;
    return newUser;
  }

  // ─── Forgot Password ───
  /// Sends a password reset email (mock — just validates the email exists).
  Future<void> sendPasswordResetEmail(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final normalizedEmail = email.trim().toLowerCase();

    if (!_accounts.containsKey(normalizedEmail)) {
      throw Exception('No account found with this email address.');
    }

    // In real app, Firebase Auth sends the reset email.
    // For now, we just simulate success.
  }

  // ─── Logout ───
  /// Logs out the current user.
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  // ─── Get User by UID ───
  /// Finds a user by their UID (for admin features later).
  UserModel? getUserByUid(String uid) {
    for (final account in _accounts.values) {
      if (account.user.uid == uid) {
        return account.user;
      }
    }
    return null;
  }

  // ─── Get All Users (Admin) ───
  /// Returns all registered users (for admin user management).
  List<UserModel> getAllUsers() {
    return _accounts.values.map((a) => a.user).toList();
  }
}

/// Internal class to store email/password pairs with user data.
/// This is only used for mock authentication.
class _MockAccount {
  final String password;
  final UserModel user;

  _MockAccount({required this.password, required this.user});
}
