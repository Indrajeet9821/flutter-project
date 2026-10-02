import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// AuthProvider manages user authentication state, active sessions,
/// and error handling across all CCMS screens.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  // Getters
  UserModel? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Role convenience helpers
  bool get isStudent => currentUser?.isStudent ?? false;
  bool get isStaff => currentUser?.isStaff ?? false;
  bool get isAdmin => currentUser?.isAdmin ?? false;
  String get userRole => currentUser?.role ?? 'Guest';

  /// Clear any pending error messages
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Sign in with email/ID and password
  Future<bool> login({
    required String emailOrStudentId,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(
        emailOrStudentId: emailOrStudentId,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Register a new account
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String department,
    String? studentId,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(
        name: name,
        email: email,
        phone: phone,
        role: role,
        department: department,
        studentId: studentId,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Request password reset link
  Future<bool> sendPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordReset(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Sign out current user
  Future<void> logout() async {
    await _authService.logout();
    _errorMessage = null;
    notifyListeners();
  }
}
