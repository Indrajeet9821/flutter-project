import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/complaint_card.dart';
import '../auth/login_screen.dart';
import '../complaint/complaint_details_screen.dart';

/// Complete Teacher/Staff Portal with Dashboard, Assigned Complaints,
/// Status Updates, and Profile
class StaffMainScreen extends StatefulWidget {
  const StaffMainScreen({super.key});

  @override
  State<StaffMainScreen> createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final complaintProvider =
          Provider.of<ComplaintProvider>(context, listen: false);
      complaintProvider.loadStaffDashboard(
        staffName: authProvider.currentUser?.name,
        department: authProvider.currentUser?.department,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final unreadCount = complaintProvider.unreadNotificationCount;

    final screens = [
      _buildStaffDashboardTab(),
      _buildAssignedComplaintsTab(),
      _buildStaffNotificationsTab(),
      _buildStaffProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_outlined),
            activeIcon: Icon(Icons.assignment_turned_in_rounded),
            label: 'Assigned',
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
            activeIcon: const Icon(Icons.notifications_rounded),
            label: 'Alerts',
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

  // --- Tab 0: Staff Dashboard ---
  Widget _buildStaffDashboardTab() {
    final authProvider = Provider.of<AuthProvider>(context);
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final user = authProvider.currentUser;
    final stats = complaintProvider.staffStats;
    final assigned = complaintProvider.staffComplaints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty & Staff Portal'),
        backgroundColor: const Color(0xFF0D9488), // Teal for Staff
      ),
      body: RefreshIndicator(
        onRefresh: () => complaintProvider.loadStaffDashboard(
          staffName: user?.name,
          department: user?.department,
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Staff Officer Portal',
                                style: TextStyle(color: Color(0xFF99F6E4), fontSize: 12),
                              ),
                              Text(
                                user?.name ?? 'Prof. Anjali Verma',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Dept: ${user?.department ?? "Information Technology"} • ${user?.studentId ?? "EMP-IT-108"}',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Department Workload Metrics',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Metrics 2x2
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Assigned Complaints',
                      count: stats['total'] ?? 0,
                      icon: Icons.assignment_late_outlined,
                      color: const Color(0xFF0D9488),
                      onTap: () => setState(() => _currentIndex = 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DashboardCard(
                      title: 'In Progress',
                      count: stats['inProgress'] ?? 0,
                      icon: Icons.engineering_outlined,
                      color: const Color(0xFFEA580C),
                      onTap: () => setState(() => _currentIndex = 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Pending Review',
                      count: stats['pending'] ?? 0,
                      icon: Icons.hourglass_empty_rounded,
                      color: const Color(0xFFD97706),
                      onTap: () => setState(() => _currentIndex = 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DashboardCard(
                      title: 'Resolved',
                      count: stats['resolved'] ?? 0,
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xFF16A34A),
                      onTap: () => setState(() => _currentIndex = 1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Assigned Tasks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _currentIndex = 1),
                    child: const Text('View All →'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (assigned.isEmpty)
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Center(
                    child: Text(
                      'No complaints currently assigned.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                )
              else
                ...assigned.take(3).map(
                  (complaint) => ComplaintCard(
                    complaint: complaint,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ComplaintDetailsScreen(complaint: complaint),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Tab 1: Assigned Complaints List ---
  Widget _buildAssignedComplaintsTab() {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final complaints = complaintProvider.staffComplaints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Complaints'),
        backgroundColor: const Color(0xFF0D9488),
      ),
      body: complaints.isEmpty
          ? const Center(child: Text('No assigned complaints found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final item = complaints[index];
                return ComplaintCard(
                  complaint: item,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ComplaintDetailsScreen(complaint: item),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  // --- Tab 2: Staff Notifications ---
  Widget _buildStaffNotificationsTab() {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final notifs = complaintProvider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Alerts'),
        backgroundColor: const Color(0xFF0D9488),
      ),
      body: notifs.isEmpty
          ? const Center(child: Text('No notifications at this time.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final n = notifs[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(n.message, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // --- Tab 3: Staff Profile ---
  Widget _buildStaffProfileTab() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Profile'),
        backgroundColor: const Color(0xFF0D9488),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.15),
              child: const Icon(Icons.person, size: 48, color: Color(0xFF0D9488)),
            ),
            const SizedBox(height: 14),
            Text(user?.name ?? 'Prof. Anjali Verma', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            Text(user?.role ?? 'Teacher/Staff', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildRow('Email', user?.email ?? 'staff@college.edu'),
                    const Divider(height: 20),
                    _buildRow('Department', user?.department ?? 'Information Technology'),
                    const Divider(height: 20),
                    _buildRow('Employee ID', user?.studentId ?? 'EMP-IT-108'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await authProvider.logout();
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (r) => false,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
