import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import 'student_dashboard_tab.dart';
import 'student_complaints_tab.dart';
import 'student_notifications_tab.dart';
import '../profile/student_profile_tab.dart';
import 'submit_complaint_screen.dart';

/// Master container for the Student experience with Bottom Navigation Bar
class StudentMainScreen extends StatefulWidget {
  final int initialTabIndex;

  const StudentMainScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;

    // Load student complaints and stats on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final complaintProvider =
          Provider.of<ComplaintProvider>(context, listen: false);
      final studentUid = authProvider.currentUser?.uid ?? 'demo-student-001';
      complaintProvider.loadStudentDashboard(studentUid);
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _handleOpenSubmitComplaint() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const SubmitComplaintScreen()),
    );
    if (result == true && mounted) {
      setState(() {
        _currentIndex = 1; // Auto switch to Complaints tab to show the new complaint!
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final unreadCount = complaintProvider.unreadNotificationCount;

    final screens = [
      StudentDashboardTab(
        onNavigateTab: _onTabSelected,
        onSubmitComplaint: _handleOpenSubmitComplaint,
      ),
      StudentComplaintsTab(
        onSubmitComplaint: _handleOpenSubmitComplaint,
      ),
      const StudentNotificationsTab(),
      const StudentProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      floatingActionButton: _currentIndex < 2
          ? FloatingActionButton.extended(
              onPressed: _handleOpenSubmitComplaint,
              backgroundColor: const Color(0xFF0D9488),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                'New Complaint',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Complaints',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined),
                if (unreadCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                    ),
                  ),
              ],
            ),
            activeIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_rounded),
                if (unreadCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                    ),
                  ),
              ],
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
