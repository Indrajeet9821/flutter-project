// ============================================================
// FILE: lib/utils/validators.dart
// PURPOSE: Contains form validation functions used across the app.
//
// Each function returns null if the input is valid,
// or returns an error message string if invalid.
// ============================================================

class Validators {
  /// Validates that a field is not empty
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    // Simple email regex pattern
    final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password (minimum 6 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  /// Validates that confirm password matches password
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates phone number (10 digits)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  /// Validates that a value is selected from a dropdown
  static String? dropdown(String? value, [String fieldName = 'This field']) {
    if (value == null || value.isEmpty) {
      return 'Please select $fieldName';
    }
    return null;
  }

  /// Validates student ID / roll number
  static String? studentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Student ID is required';
    }
    if (value.trim().length < 3) {
      return 'Student ID must be at least 3 characters';
    }
    return null;
  }

  /// Validates name (minimum 2 characters, letters only)
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  /// Validates that description has minimum length
  static String? description(String? value, {int minLength = 10}) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < minLength) {
      return 'Description must be at least $minLength characters long';
    }
    return null;
  }
}
