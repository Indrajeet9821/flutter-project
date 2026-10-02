import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/complaint_card.dart';
import '../auth/login_screen.dart';
import '../complaint/complaint_details_screen.dart';

/// Complete Administrator Portal with Oversight Dashboard, Assignment,
/// Management of Categories/Departments/Locations, Reports, and Analytics.
class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ComplaintProvider>(context, listen: false).loadAdminDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildAdminDashboardTab(),
      _buildAllComplaintsTab(),
      _buildCampusManagementTab(),
      _buildReportsTab(),
      _buildAdminProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF7C3AED), // Purple for Admin
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open_outlined),
            activeIcon: Icon(Icons.folder_rounded),
            label: 'Complaints',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_rounded),
            activeIcon: Icon(Icons.tune),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            activeIcon: Icon(Icons.insert_chart_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            activeIcon: Icon(Icons.admin_panel_settings_rounded),
            label: 'Admin',
          ),
        ],
      ),
    );
  }

  // --- Tab 0: Admin Dashboard ---
  Widget _buildAdminDashboardTab() {
    final authProvider = Provider.of<AuthProvider>(context);
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final user = authProvider.currentUser;
    final stats = complaintProvider.adminStats;
    final allComplaints = complaintProvider.allComplaints;

    final byCategory = stats['byCategory'] as Map<String, int>? ?? {};
    final byDept = stats['byDepartment'] as Map<String, int>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Central Control'),
        backgroundColor: const Color(0xFF7C3AED),
      ),
      body: RefreshIndicator(
        onRefresh: () => complaintProvider.loadAdminDashboard(),
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
                    colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
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
                          child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Chief Administrator Oversight',
                                style: TextStyle(color: Color(0xFFDDD6FE), fontSize: 12),
                              ),
                              Text(
                                user?.name ?? 'Dr. Suresh Kumar',
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
                    const Text(
                      'College Grievance Redressal Committee • Central Management',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Campus Grievance Metrics',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 2x2 Grid
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Total Lodged',
                      count: stats['total'] ?? 0,
                      icon: Icons.inventory_2_outlined,
                      color: const Color(0xFF7C3AED),
                      onTap: () => setState(() => _currentIndex = 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DashboardCard(
                      title: 'Urgent Action',
                      count: stats['urgent'] ?? 0,
                      icon: Icons.warning_amber_rounded,
                      color: const Color(0xFFDC2626),
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
                      title: 'In Progress',
                      count: stats['inProgress'] ?? 0,
                      icon: Icons.engineering_outlined,
                      color: const Color(0xFFEA580C),
                      onTap: () => setState(() => _currentIndex = 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DashboardCard(
                      title: 'Resolved',
                      count: (stats['resolved'] ?? 0) + (stats['closed'] ?? 0),
                      icon: Icons.verified_outlined,
                      color: const Color(0xFF16A34A),
                      onTap: () => setState(() => _currentIndex = 1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Category Breakdown Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Complaints by Category',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (byCategory.isEmpty)
                        const Text('No data recorded yet.', style: TextStyle(fontSize: 12, color: Colors.grey))
                      else
                        ...byCategory.entries.map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(e.key, style: const TextStyle(fontSize: 12))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${e.value}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF7C3AED)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Department Breakdown Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Complaints by Department',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (byDept.isEmpty)
                        const Text('No data recorded yet.', style: TextStyle(fontSize: 12, color: Colors.grey))
                      else
                        ...byDept.entries.map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(e.key, style: const TextStyle(fontSize: 12))),
                                Text(
                                  '${e.value} complaints',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Campus Grievance Feed',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _currentIndex = 1),
                    child: const Text('View All →'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ...allComplaints.take(3).map(
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

  // --- Tab 1: All Campus Complaints ---
  Widget _buildAllComplaintsTab() {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final complaints = complaintProvider.filteredAdminComplaints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Campus Complaints'),
        backgroundColor: const Color(0xFF7C3AED),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextField(
              onChanged: (val) => complaintProvider.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search by student, ID, department, category...',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: complaints.isEmpty
                ? const Center(child: Text('No complaints match search.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
          ),
        ],
      ),
    );
  }

  // --- Tab 2: Campus Management (Categories, Departments, Locations) ---
  Widget _buildCampusManagementTab() {
    final complaintProvider = Provider.of<ComplaintProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Configuration'),
        backgroundColor: const Color(0xFF7C3AED),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildManagementSection(
            title: 'Complaint Categories (${complaintProvider.categories.length})',
            items: complaintProvider.categories,
            onAdd: (name) => complaintProvider.addCategory(name),
            onRemove: (name) => complaintProvider.removeCategory(name),
          ),
          const SizedBox(height: 16),
          _buildManagementSection(
            title: 'Departments (${complaintProvider.departments.length})',
            items: complaintProvider.departments,
            onAdd: (name) => complaintProvider.addDepartment(name),
            onRemove: (name) => complaintProvider.removeDepartment(name),
          ),
          const SizedBox(height: 16),
          _buildManagementSection(
            title: 'Campus Locations (${complaintProvider.locations.length})',
            items: complaintProvider.locations,
            onAdd: (name) => complaintProvider.addLocation(name),
            onRemove: (name) => complaintProvider.removeLocation(name),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementSection({
    required String title,
    required List<String> items,
    required Function(String) onAdd,
    required Function(String) onRemove,
  }) {
    final controller = TextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Color(0xFF7C3AED)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Add New to $title'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.text.trim().isNotEmpty) {
                                onAdd(controller.text.trim());
                                Navigator.of(ctx).pop();
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: items.map((item) {
                return Chip(
                  label: Text(item, style: const TextStyle(fontSize: 11)),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () => onRemove(item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- Tab 3: Reports & Analytics ---
  Widget _buildReportsTab() {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final stats = complaintProvider.adminStats;
    final total = stats['total'] ?? 0;
    final resolved = (stats['resolved'] ?? 0) + (stats['closed'] ?? 0);
    final resolutionRate = total > 0 ? ((resolved / total) * 100).toStringAsFixed(1) : '100';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grievance Redressal Reports'),
        backgroundColor: const Color(0xFF7C3AED),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Campus Resolution Rate', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    const SizedBox(height: 6),
                    Text(
                      '$resolutionRate%',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)),
                    ),
                    const SizedBox(height: 4),
                    Text('$resolved of $total complaints resolved', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Audit & Compliance Checklist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    _buildAuditItem('Grievance Redressal Cell Formed', true),
                    _buildAuditItem('24-Hour Review Target Met', true),
                    _buildAuditItem('72-Hour Resolution SLA Active', true),
                    _buildAuditItem('Student Feedback Channel Open', true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditItem(String text, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(active ? Icons.check_circle : Icons.radio_button_unchecked, size: 16, color: const Color(0xFF16A34A)),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // --- Tab 4: Admin Profile ---
  Widget _buildAdminProfileTab() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrator Profile'),
        backgroundColor: const Color(0xFF7C3AED),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.15),
              child: const Icon(Icons.admin_panel_settings_rounded, size: 48, color: Color(0xFF7C3AED)),
            ),
            const SizedBox(height: 14),
            Text(user?.name ?? 'Dr. Suresh Kumar', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            Text(user?.role ?? 'Administrator', style: const TextStyle(fontSize: 12, color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAdminRow('Email', user?.email ?? 'admin@college.edu'),
                    const Divider(height: 20),
                    _buildAdminRow('Office', user?.department ?? 'Administrative Office'),
                    const Divider(height: 20),
                    _buildAdminRow('Admin ID', user?.studentId ?? 'ADM-001'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sign Out Administrator', style: TextStyle(color: Colors.red)),
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

  Widget _buildAdminRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
