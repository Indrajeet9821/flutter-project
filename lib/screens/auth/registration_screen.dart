// ============================================================
// FILE: lib/screens/auth/registration_screen.dart
// PURPOSE: Student registration screen.
//
// Fields:
// - Full name, Student ID, Email, Phone
// - Department (dropdown), Year (dropdown)
// - Password, Confirm password
//
// All fields are validated before submission.
// On success, navigates to the Student Dashboard.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../student/student_dashboard.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Dropdown values
  String? _selectedDepartment;
  String? _selectedYear;

  // Password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle registration
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearError();

    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      department: _selectedDepartment!,
      studentId: _studentIdController.text.trim(),
      year: _selectedYear!,
    );

    if (!mounted) return;

    if (success) {
      Helpers.showSuccessSnackbar(
        context,
        'Registration successful! Welcome to CCMS.',
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const StudentDashboard()),
        (route) => false, // Remove all previous routes
      );
    } else {
      Helpers.showErrorSnackbar(
        context,
        authProvider.errorMessage ?? 'Registration failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with back button
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Container(
        color: AppTheme.scaffoldBackground,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // ─── Header ───
              _buildHeader(),

              const SizedBox(height: 28),

              // ─── Registration Form ───
              _buildRegistrationForm(),

              const SizedBox(height: 20),

              // ─── Already have account ───
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Login'),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppTheme.softShadow,
          ),
          child: const Icon(
            Icons.person_add_rounded,
            size: 35,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Student Registration',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Fill in your details to create an account',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Personal Info
            _buildSectionLabel('Personal Information'),
            const SizedBox(height: 12),

            // Full Name
            CustomTextField(
              controller: _nameController,
              label: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: Validators.name,
            ),
            const SizedBox(height: 16),

            // Student ID
            CustomTextField(
              controller: _studentIdController,
              label: 'Student ID / Roll Number',
              hintText: 'e.g., CS2024001',
              prefixIcon: Icons.badge_outlined,
              textInputAction: TextInputAction.next,
              validator: Validators.studentId,
            ),
            const SizedBox(height: 16),

            // Email
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),

            // Phone
            CustomTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hintText: 'Enter 10-digit phone number',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: Validators.phone,
            ),

            const SizedBox(height: 24),

            // Section: Academic Info
            _buildSectionLabel('Academic Information'),
            const SizedBox(height: 12),

            // Department dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedDepartment,
              decoration: const InputDecoration(
                labelText: 'Department',
                prefixIcon: Icon(Icons.business_outlined),
              ),
              items: AppConstants.departments.map((dept) {
                return DropdownMenuItem(value: dept, child: Text(dept));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
              validator: (value) => Validators.dropdown(value, 'a department'),
            ),
            const SizedBox(height: 16),

            // Year dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedYear,
              decoration: const InputDecoration(
                labelText: 'Year',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              items: AppConstants.years.map((year) {
                return DropdownMenuItem(value: year, child: Text(year));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value;
                });
              },
              validator: (value) => Validators.dropdown(value, 'a year'),
            ),

            const SizedBox(height: 24),

            // Section: Security
            _buildSectionLabel('Security'),
            const SizedBox(height: 12),

            // Password
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Minimum 6 characters',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              validator: Validators.password,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppTheme.textHint,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hintText: 'Re-enter your password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleRegister(),
              validator: (value) =>
                  Validators.confirmPassword(value, _passwordController.text),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppTheme.textHint,
                ),
                onPressed: () {
                  setState(() =>
                      _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Error message
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (auth.errorMessage != null) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.errorColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppTheme.errorColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            auth.errorMessage!,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppTheme.errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Register button
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return PrimaryButton(
                  text: 'Create Account',
                  isLoading: auth.isLoading,
                  icon: Icons.person_add_rounded,
                  onPressed: _handleRegister,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
