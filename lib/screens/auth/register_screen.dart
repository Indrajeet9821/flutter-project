import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Screen allowing students, staff, and administrators to register an account
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Selection states
  String _selectedRole = AppConstants.roleStudent;
  String _selectedDepartment = AppConstants.defaultDepartments.first;
  String _selectedYear = '1st Year';

  final List<String> _academicYears = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
    'Post Graduate',
    'N/A (Staff/Admin)',
  ];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedRole,
      department: _selectedDepartment,
      studentId: _idController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      AppHelpers.showSnackBar(
        context,
        'Account created successfully! Welcome, ${authProvider.currentUser?.name}.',
        isSuccess: true,
      );
      Navigator.of(context).pop(); // Back to Login or will auto-direct
    } else {
      AppHelpers.showSnackBar(
        context,
        authProvider.errorMessage ?? 'Registration failed. Please try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const Text(
                  'Join CCMS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Register your profile to submit or manage college grievances.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 24),

                // Role Selector
                const Text(
                  'Select Account Role',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: AppConstants.userRoles.map((role) {
                    final isSelected = _selectedRole == role;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(
                            role,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textPrimaryLight,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryColor,
                          backgroundColor: Colors.grey.shade100,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedRole = role;
                                if (_selectedRole != AppConstants.roleStudent) {
                                  _selectedYear = 'N/A (Staff/Admin)';
                                } else {
                                  _selectedYear = '1st Year';
                                }
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Full Name
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'e.g. John Doe',
                  prefixIcon: Icons.person_outline,
                  validator: (v) =>
                      AppValidators.validateRequired(v, 'Full Name'),
                ),

                const SizedBox(height: 16),

                // Student ID or Employee ID
                CustomTextField(
                  controller: _idController,
                  label: _selectedRole == AppConstants.roleStudent
                      ? 'Student ID / Roll Number'
                      : 'Employee / Staff ID',
                  hint: _selectedRole == AppConstants.roleStudent
                      ? 'e.g. CS-2024-042'
                      : 'e.g. EMP-IT-108',
                  prefixIcon: Icons.badge_outlined,
                  validator: (v) => AppValidators.validateRequired(
                    v,
                    _selectedRole == AppConstants.roleStudent
                        ? 'Student ID'
                        : 'Staff ID',
                  ),
                ),

                const SizedBox(height: 16),

                // College Email
                CustomTextField(
                  controller: _emailController,
                  label: 'College Email Address',
                  hint: 'e.g. student@college.edu',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.validateEmail,
                ),

                const SizedBox(height: 16),

                // Phone Number
                CustomTextField(
                  controller: _phoneController,
                  label: 'Contact Phone Number',
                  hint: 'e.g. 9876543210',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: AppValidators.validatePhone,
                ),

                const SizedBox(height: 16),

                // Department Dropdown
                const Text(
                  'Department',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDepartment,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.apartment_outlined, size: 20),
                  ),
                  items: AppConstants.defaultDepartments.map((dept) {
                    return DropdownMenuItem(
                      value: dept,
                      child: Text(dept, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedDepartment = value);
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Academic Year / Semester (if Student)
                if (_selectedRole == AppConstants.roleStudent) ...[
                  const Text(
                    'Year / Semester',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedYear,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.school_outlined, size: 20),
                    ),
                    items: _academicYears
                        .where((y) => y != 'N/A (Staff/Admin)')
                        .map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedYear = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Password
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'At least 6 characters',
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

                const SizedBox(height: 16),

                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  prefixIcon: Icons.lock_clock_outlined,
                  obscureText: _obscureConfirmPassword,
                  validator: (v) => AppValidators.validateConfirmPassword(
                    v,
                    _passwordController.text,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirmPassword =
                          !_obscureConfirmPassword);
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // Submit Button
                CustomButton(
                  text: 'Create CCMS Account',
                  icon: Icons.person_add_alt_1_rounded,
                  isLoading: authProvider.isLoading,
                  onPressed: _handleRegister,
                ),

                const SizedBox(height: 16),

                // Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already registered? ',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
