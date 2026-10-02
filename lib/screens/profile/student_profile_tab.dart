import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/helpers.dart';
import '../auth/login_screen.dart';

/// Tab 3: Student Profile Tab
class StudentProfileTab extends StatelessWidget {
  const StudentProfileTab({super.key});

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Sign Out'),
        content: const Text(
          'Are you sure you want to sign out of your college student account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final user = authProvider.currentUser;
    final stats = complaintProvider.studentStats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Avatar Card
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.12),
                    child: Text(
                      user?.name.isNotEmpty == true
                          ? user!.name
                              .split(' ')
                              .map((n) => n[0])
                              .take(2)
                              .join('')
                          : 'RS',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Student Name & ID
            Text(
              user?.name ?? 'Rahul Sharma',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Roll No: ${user?.studentId ?? "CS-2024-042"}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),

            const SizedBox(height: 18),

            // Mini Stats Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total', '${stats["total"] ?? 0}', AppTheme.primaryColor),
                  Container(height: 30, width: 1, color: Colors.grey.shade200),
                  _buildStatItem('Pending', '${stats["pending"] ?? 0}', const Color(0xFFD97706)),
                  Container(height: 30, width: 1, color: Colors.grey.shade200),
                  _buildStatItem('Resolved', '${stats["resolved"] ?? 0}', const Color(0xFF16A34A)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Academic & Contact Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoTile(
                      Icons.email_outlined,
                      'Email Address',
                      user?.email ?? 'student@college.edu',
                    ),
                    const Divider(height: 20),
                    _buildInfoTile(
                      Icons.phone_outlined,
                      'Contact Number',
                      user?.phone ?? '+91 9876543210',
                    ),
                    const Divider(height: 20),
                    _buildInfoTile(
                      Icons.apartment_outlined,
                      'Department',
                      user?.department ?? 'Computer Science',
                    ),
                    const Divider(height: 20),
                    _buildInfoTile(
                      Icons.calendar_today_outlined,
                      'Member Since',
                      user != null ? AppHelpers.formatDate(user.createdAt) : 'Jan 2026',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Profile Actions
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline_rounded, color: Color(0xFF475569)),
                    title: const Text('Change Password', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () {
                      AppHelpers.showSnackBar(
                        context,
                        'Password change link sent to ${user?.email}',
                        isSuccess: true,
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined, color: Color(0xFF475569)),
                    title: const Text('Notification Settings', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () {
                      AppHelpers.showSnackBar(
                        context,
                        'Grievance push notifications are enabled.',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded, color: Color(0xFF475569)),
                    title: const Text('Help & College Grievance Policy', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () {
                      AppHelpers.showSnackBar(
                        context,
                        'CCMS follows UGC Student Grievance Redressal Regulations.',
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout_rounded, color: AppTheme.errorColor),
                label: const Text(
                  'Sign Out Account',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.errorColor, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showLogoutDialog(context, authProvider),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF475569)),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
