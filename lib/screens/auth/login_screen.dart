import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import '../student/student_main_screen.dart';
import '../staff/staff_main_screen.dart';
import '../admin/admin_main_screen.dart';

/// Login Screen for CCMS
/// Supports authentication for Students, Staff, and Administrators.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Instant 1-tap demo login for testing any role
  Future<void> _quickLoginDemo(String email, String password) async {
    setState(() {
      _loginIdController.text = email;
      _passwordController.text = password;
    });
    await _handleLogin();
  }


  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      emailOrStudentId: _loginIdController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      AppHelpers.showSnackBar(
        context,
        'Welcome back, ${authProvider.currentUser?.name} (${authProvider.userRole})!',
        isSuccess: true,
      );

      // Navigate to role-specific portal
      if (authProvider.isStudent) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const StudentMainScreen(),
          ),
        );
      } else if (authProvider.isStaff) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const StaffMainScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminMainScreen(),
          ),
        );
      }
    } else {
      AppHelpers.showSnackBar(
        context,
        authProvider.errorMessage ?? 'Login failed. Please check credentials.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // College Logo Emblem
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        size: 56,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Short Name
                  const Center(
                    child: Text(
                      AppConstants.appShortName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Full Application Name
                  const Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Sign in to access your portal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // One-Tap Instant Role Portals (Instant access to Student, Staff, and Admin)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.flash_on_rounded,
                                size: 18, color: Color(0xFFD97706)),
                            const SizedBox(width: 6),
                            Text(
                              'Instant Role Portals (One-Tap Access)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildQuickChip(
                              label: 'Student',
                              subtitle: 'Rahul Sharma',
                              email: 'student@college.edu',
                              color: const Color(0xFF1E3A8A),
                              icon: Icons.school_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildQuickChip(
                              label: 'Staff',
                              subtitle: 'Prof. Verma',
                              email: 'staff@college.edu',
                              color: const Color(0xFF0D9488),
                              icon: Icons.badge_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildQuickChip(
                              label: 'Admin',
                              subtitle: 'Dr. Suresh',
                              email: 'admin@college.edu',
                              color: const Color(0xFF7C3AED),
                              icon: Icons.admin_panel_settings_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'OR SIGN IN WITH CREDENTIALS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Email or Student ID Field
                  CustomTextField(
                    controller: _loginIdController,
                    label: 'Email Address or Student ID',
                    hint: 'e.g. student@college.edu or CS-2024-042',
                    prefixIcon: Icons.badge_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => AppValidators.validateRequired(
                      v,
                      'Email or Student ID',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your account password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    validator: AppValidators.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Login Action Button
                  CustomButton(
                    text: 'Sign In to CCMS',
                    icon: Icons.login_rounded,
                    isLoading: authProvider.isLoading,
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: 24),

                  // Registration Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip({
    required String label,
    required String subtitle,
    required String email,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _quickLoginDemo(email, 'password123'),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(height: 3),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '1-Tap Login',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
