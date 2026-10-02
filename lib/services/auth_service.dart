import 'dart:async';
import '../models/user_model.dart';
import '../utils/constants.dart';

/// Authentication Service handling user login, registration, password resets,
/// and session management. Built to integrate seamlessly with Firebase Auth.
class AuthService {
  // Current active user session in memory
  UserModel? _currentUser;

  // Pre-configured demo accounts for instant testing of all three roles
  final List<Map<String, dynamic>> _demoAccounts = [
    {
      'email': 'student@college.edu',
      'password': 'password123',
      'user': UserModel(
        uid: 'demo-student-001',
        name: 'Rahul Sharma',
        email: 'student@college.edu',
        phone: '9876543210',
        role: AppConstants.roleStudent,
        department: 'Computer Science',
        studentId: 'CS-2024-042',
        createdAt: DateTime(2026, 1, 15),
      ),
    },
    {
      'email': 'staff@college.edu',
      'password': 'password123',
      'user': UserModel(
        uid: 'demo-staff-001',
        name: 'Prof. Anjali Verma',
        email: 'staff@college.edu',
        phone: '9876543211',
        role: AppConstants.roleStaff,
        department: 'Information Technology',
        studentId: 'EMP-IT-108',
        createdAt: DateTime(2025, 6, 1),
      ),
    },
    {
      'email': 'admin@college.edu',
      'password': 'password123',
      'user': UserModel(
        uid: 'demo-admin-001',
        name: 'Dr. Suresh Kumar (Chief Admin)',
        email: 'admin@college.edu',
        phone: '9876543212',
        role: AppConstants.roleAdmin,
        department: 'Administrative Office',
        studentId: 'ADM-001',
        createdAt: DateTime(2024, 1, 1),
      ),
    },
  ];

  // In-memory registered users pool (allows registering new users during session)
  final List<UserModel> _registeredUsers = [];

  AuthService() {
    // Seed initial demo users
    for (final account in _demoAccounts) {
      _registeredUsers.add(account['user'] as UserModel);
    }
  }

  /// Get currently signed-in user
  UserModel? get currentUser => _currentUser;

  /// Check if user is currently authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Authenticate user with Email/StudentId and Password
  Future<UserModel> login({
    required String emailOrStudentId,
    required String password,
  }) async {
    // Simulate brief network delay for realistic experience
    await Future.delayed(const Duration(milliseconds: 800));

    final normalizedInput = emailOrStudentId.trim().toLowerCase();

    // Check demo accounts first
    for (final account in _demoAccounts) {
      final user = account['user'] as UserModel;
      final emailMatches = user.email.toLowerCase() == normalizedInput;
      final studentIdMatches =
          user.studentId?.toLowerCase() == normalizedInput;

      if (emailMatches || studentIdMatches) {
        if (password == account['password']) {
          _currentUser = user;
          return user;
        } else {
          throw 'Incorrect password. Please try again.';
        }
      }
    }

    // Check dynamically registered users
    for (final user in _registeredUsers) {
      final emailMatches = user.email.toLowerCase() == normalizedInput;
      final studentIdMatches =
          user.studentId?.toLowerCase() == normalizedInput;

      if (emailMatches || studentIdMatches) {
        // For dynamically registered users in demo mode, accept valid password
        if (password.length >= 6) {
          _currentUser = user;
          return user;
        } else {
          throw 'Incorrect password. Please try again.';
        }
      }
    }

    throw 'No account found matching "$emailOrStudentId". Please check your credentials or register.';
  }

  /// Register a new user
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String department,
    String? studentId,
    required String password,
  }) async {
    // Simulate brief network latency
    await Future.delayed(const Duration(milliseconds: 900));

    final normalizedEmail = email.trim().toLowerCase();

    // Check if email already exists
    final emailExists = _registeredUsers.any(
      (u) => u.email.toLowerCase() == normalizedEmail,
    );
    if (emailExists) {
      throw 'An account with this email address already exists.';
    }

    // Check if student ID already exists (for students)
    if (studentId != null && studentId.trim().isNotEmpty) {
      final idExists = _registeredUsers.any(
        (u) =>
            u.studentId != null &&
            u.studentId!.toLowerCase() == studentId.trim().toLowerCase(),
      );
      if (idExists) {
        throw 'An account with this Student ID / Roll Number already exists.';
      }
    }

    // Create new user model
    final newUser = UserModel(
      uid: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      role: role,
      department: department,
      studentId: studentId?.trim(),
      createdAt: DateTime.now(),
    );

    _registeredUsers.add(newUser);
    _currentUser = newUser;
    return newUser;
  }

  /// Send password reset instructions
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final normalizedEmail = email.trim().toLowerCase();
    final userExists = _registeredUsers.any(
      (u) => u.email.toLowerCase() == normalizedEmail,
    );

    if (!userExists) {
      throw 'No registered user found with email "$email".';
    }

    // Password reset simulation successful
    return;
  }

  /// Log out current user
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}
