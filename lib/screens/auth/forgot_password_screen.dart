// ============================================================
// FILE: lib/screens/auth/forgot_password_screen.dart
// PURPOSE: Forgot password screen.
//
// Allows users to enter their email to receive a password
// reset link. Shows success/error feedback.
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearError();

    final success = await authProvider.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      setState(() => _emailSent = true);
      Helpers.showSuccessSnackbar(
        context,
        'Password reset link sent to your email!',
      );
    } else {
      Helpers.showErrorSnackbar(
        context,
        authProvider.errorMessage ?? 'Failed to send reset email.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Container(
        color: AppTheme.scaffoldBackground,
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // ─── Icon ───
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _emailSent
                      ? AppTheme.successColor.withValues(alpha: 0.1)
                      : AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _emailSent
                      ? Icons.mark_email_read_rounded
                      : Icons.lock_reset_rounded,
                  size: 40,
                  color: _emailSent
                      ? AppTheme.successColor
                      : AppTheme.primaryColor,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                _emailSent ? 'Email Sent!' : 'Reset Password',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _emailSent
                      ? 'We have sent a password reset link to your email. Please check your inbox and follow the instructions.'
                      : 'Enter your registered email address and we will send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              if (!_emailSent) ...[
                // ─── Form ───
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hintText: 'Enter your registered email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleResetPassword(),
                          validator: Validators.email,
                        ),

                        const SizedBox(height: 8),

                        // Error message
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) {
                            if (auth.errorMessage != null) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.errorColor
                                        .withValues(alpha: 0.3),
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

                        const SizedBox(height: 16),

                        Consumer<AuthProvider>(
                          builder: (context, auth, _) {
                            return PrimaryButton(
                              text: 'Send Reset Link',
                              isLoading: auth.isLoading,
                              icon: Icons.send_rounded,
                              onPressed: _handleResetPassword,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // ─── Success State ───
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: 'Back to Login',
                        icon: Icons.login_rounded,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          setState(() => _emailSent = false);
                          _emailController.clear();
                        },
                        child: const Text('Try a different email'),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
