// ============================================================
// FILE: lib/providers/auth_provider.dart
// PURPOSE: State management for authentication.
//
// Uses the Provider package to manage auth state across the app.
// Connects the UI (screens) to the AuthService (business logic).
//
// The UI calls methods on this provider, which calls AuthService,
// and then notifies all listeners (screens) to rebuild.
// ============================================================

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // ─── State Variables ───
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // ─── Getters ───
  /// The currently logged-in user (null if not logged in)
  UserModel? get user => _user;

  /// True while a login/register/reset operation is in progress
  bool get isLoading => _isLoading;

  /// Error message from the last failed operation (null if no error)
  String? get errorMessage => _errorMessage;

  /// True if a user is logged in
  bool get isLoggedIn => _user != null;

  /// The current user's role ('student', 'staff', 'admin')
  String get userRole => _user?.role ?? '';

  // ─── Login ───
  /// Attempts to log in. Returns true on success, false on failure.
  /// On failure, errorMessage is set with the reason.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ─── Register ───
  /// Registers a new student account. Returns true on success.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String department,
    required String studentId,
    required String year,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        department: department,
        studentId: studentId,
        year: year,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ─── Forgot Password ───
  /// Sends a password reset email. Returns true on success.
  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ─── Logout ───
  /// Logs out the current user.
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _user = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  // ─── Clear Error ───
  /// Clears the error message (e.g., when user starts typing again)
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
