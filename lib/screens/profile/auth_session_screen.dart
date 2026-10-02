import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';
import '../student/student_main_screen.dart';

/// Screen displayed immediately upon login, confirming active authenticated session
/// and displaying role-specific status and profile information.
class AuthSessionScreen extends StatelessWidget {
  const AuthSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    final roleColor = user.isAdmin
        ? const Color(0xFF7C3AED)
        : user.isStaff
            ? const Color(0xFF0D9488)
            : const Color(0xFF2563EB);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CCMS Session'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Log Out',
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Profile Banner Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: roleColor.withValues(alpha: 0.15),
                        child: Icon(
                          user.isAdmin
                              ? Icons.admin_panel_settings_rounded
                              : user.isStaff
                                  ? Icons.person_rounded
                                  : Icons.school_rounded,
                          size: 44,
                          color: roleColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        user.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Role Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: roleColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: TextStyle(
                            color: roleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(),

                      // Profile Details
                      _buildProfileRow(Icons.email_outlined, 'Email', user.email),
                      const SizedBox(height: 10),
                      _buildProfileRow(Icons.phone_outlined, 'Phone', user.phone),
                      const SizedBox(height: 10),
                      _buildProfileRow(
                        Icons.apartment_outlined,
                        'Department',
                        user.department,
                      ),
                      if (user.studentId != null) ...[
                        const SizedBox(height: 10),
                        _buildProfileRow(
                          Icons.badge_outlined,
                          user.isStudent ? 'Roll Number / ID' : 'Staff ID',
                          user.studentId!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Authentication Success Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: Colors.green.shade700, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Authentication Succeeded!',
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Session active for ${user.email}. Phase 2 authentication pipeline is complete.',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Role Capabilities Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Role Permissions: ${user.role}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (user.isStudent) ...[
                        _buildPermissionItem('Submit new complaints with categories & priorities'),
                        _buildPermissionItem('Track complaint status lifecycle (Submitted → Closed)'),
                        _buildPermissionItem('Provide 1–5 star rating and feedback after resolution'),
                        _buildPermissionItem('Receive progress notifications'),
                      ] else if (user.isStaff) ...[
                        _buildPermissionItem('View complaints assigned to department'),
                        _buildPermissionItem('Update complaint progress & add comments'),
                        _buildPermissionItem('Mark complaints as resolved with resolution proof'),
                      ] else ...[
                        _buildPermissionItem('Full administrator oversight of all campus complaints'),
                        _buildPermissionItem('Assign complaints to faculty & maintenance staff'),
                        _buildPermissionItem('Manage students, departments, locations & categories'),
                        _buildPermissionItem('View campus grievance analytics & performance reports'),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (user.isStudent) ...[
                CustomButton(
                  text: 'Enter Student Portal Dashboard',
                  icon: Icons.dashboard_rounded,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const StudentMainScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],

              // Logout / Switch User Button
              CustomButton(
                text: 'Sign Out / Switch Account',
                icon: Icons.logout_rounded,
                isOutlined: true,
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 14),

              // Return to Login Screen link
              Center(
                child: Text(
                  '${AppConstants.appShortName} v${AppConstants.appVersion}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline,
              size: 16, color: Color(0xFF16A34A)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }
}
