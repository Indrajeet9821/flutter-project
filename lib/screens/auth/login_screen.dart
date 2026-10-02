// ============================================================
// FILE: lib/screens/auth/login_screen.dart
// PURPOSE: Full login screen with validation and auth.
//
// Features:
// - Email and password fields with validation
// - Show/hide password toggle
// - Login button with loading state
// - Error message display
// - Links to Registration and Forgot Password
// - Role-based navigation after login
// - Demo account info for easy testing
// ============================================================

import 'package:flutter/material.dart';
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
import '../staff/staff_dashboard.dart';
import '../admin/admin_dashboard.dart';
import 'registration_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  bool _obscurePassword = true;

  // Animation
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  /// Handle login button press
  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Clear any previous errors
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearError();

    // Attempt login
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Helpers.showSuccessSnackbar(context, 'Login successful! Welcome back.');
      _navigateToDashboard(authProvider.userRole);
    } else {
      Helpers.showErrorSnackbar(
        context,
        authProvider.errorMessage ?? 'Login failed. Please try again.',
      );
    }
  }

  /// Navigate to the correct dashboard based on user role
  void _navigateToDashboard(String role) {
    Widget dashboard;
    switch (role) {
      case 'staff':
        dashboard = const StaffDashboard();
        break;
      case 'admin':
        dashboard = const AdminDashboard();
        break;
      case 'student':
      default:
        dashboard = const StudentDashboard();
        break;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => dashboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.scaffoldBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 48),

                    // ─── Logo & Title ───
                    _buildHeader(),

                    const SizedBox(height: 40),

                    // ─── Login Form ───
                    _buildLoginForm(),

                    const SizedBox(height: 24),

                    // ─── Create Account Link ───
                    _buildCreateAccountLink(),

                    const SizedBox(height: 24),

                    // ─── Demo Accounts Info ───
                    _buildDemoAccountsInfo(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the header with icon and app name
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppTheme.softShadow,
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 45,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppConstants.appShortName,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppConstants.appName,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Builds the login form card
  Widget _buildLoginForm() {
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
            Text(
              'Welcome Back',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sign in to continue',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 28),

            // Email field
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
              onChanged: (_) {
                // Clear error when user types
                Provider.of<AuthProvider>(context, listen: false).clearError();
              },
            ),

            const SizedBox(height: 16),

            // Password field
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleLogin(),
              validator: Validators.password,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppTheme.textHint,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),

            const SizedBox(height: 8),

            // Forgot Password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text('Forgot Password?'),
              ),
            ),

            const SizedBox(height: 8),

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
                        const Icon(
                          Icons.error_outline,
                          color: AppTheme.errorColor,
                          size: 20,
                        ),
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

            // Login button
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return PrimaryButton(
                  text: 'Login',
                  isLoading: auth.isLoading,
                  icon: Icons.login_rounded,
                  onPressed: _handleLogin,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the "Create Account" link row
  Widget _buildCreateAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RegistrationScreen(),
              ),
            );
          },
          child: const Text('Create Account'),
        ),
      ],
    );
  }

  /// Shows demo account credentials for easy testing
  Widget _buildDemoAccountsInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.infoColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppTheme.infoColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Demo Accounts (Password: 123456)',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.infoColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDemoRow('Student', 'student@ccms.com'),
          const SizedBox(height: 4),
          _buildDemoRow('Staff', 'staff@ccms.com'),
          const SizedBox(height: 4),
          _buildDemoRow('Admin', 'admin@ccms.com'),
        ],
      ),
    );
  }

  Widget _buildDemoRow(String role, String email) {
    return InkWell(
      onTap: () {
        _emailController.text = email;
        _passwordController.text = '123456';
      },
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                '$role:',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.content_copy,
              size: 14,
              color: AppTheme.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
