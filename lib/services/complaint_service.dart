import 'dart:async';
import '../models/complaint_model.dart';
import '../models/notification_model.dart';
import '../models/feedback_model.dart';
import '../utils/constants.dart';

/// Extended ComplaintService providing full CRUD, multi-role querying,
/// assignment, status updates, comments, feedback, and dynamic lists.
class ComplaintService {
  final List<ComplaintModel> _complaints = [];
  final List<NotificationModel> _notifications = [];
  final List<Map<String, dynamic>> _comments = [];
  final List<FeedbackModel> _feedbacks = [];

  // Dynamic system lists that administrators can modify
  final List<String> _categories = List.from(AppConstants.defaultCategories);
  final List<String> _departments = List.from(AppConstants.defaultDepartments);
  final List<String> _locations = List.from(AppConstants.defaultLocations);

  int _complaintCounter = 5;

  ComplaintService() {
    _seedInitialData();
  }

  void _seedInitialData() {
    final now = DateTime.now();

    _complaints.addAll([
      ComplaintModel(
        complaintId: 'CMP-2026-0001',
        studentUid: 'demo-student-001',
        studentId: 'CS-2024-042',
        studentName: 'Rahul Sharma',
        department: 'Computer Science',
        category: 'Laboratory',
        title: 'Faulty AC in Computer Lab 3',
        description:
            'The central air conditioner in Lab 3 has been malfunctioning for 2 days. The systems overheat quickly during afternoon practical sessions.',
        location: 'Block B',
        priority: AppConstants.priorityHigh,
        status: AppConstants.statusInProgress,
        assignedTo: 'Prof. Anjali Verma',
        createdAt: now.subtract(const Duration(days: 2, hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
      ComplaintModel(
        complaintId: 'CMP-2026-0002',
        studentUid: 'demo-student-001',
        studentId: 'CS-2024-042',
        studentName: 'Rahul Sharma',
        department: 'Computer Science',
        category: 'Internet/Wi-Fi',
        title: 'Campus Wi-Fi connectivity dropped in Library 2nd Floor',
        description:
            'The Wi-Fi access point near the digital reference section has no internet access since yesterday morning.',
        location: 'Library',
        priority: AppConstants.priorityUrgent,
        status: AppConstants.statusUnderReview,
        assignedTo: 'IT Staff',
        createdAt: now.subtract(const Duration(hours: 18)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
      ComplaintModel(
        complaintId: 'CMP-2026-0003',
        studentUid: 'demo-student-001',
        studentId: 'CS-2024-042',
        studentName: 'Rahul Sharma',
        department: 'Computer Science',
        category: 'Drinking Water',
        title: 'Water cooler leaking in Block A 1st Floor',
        description:
            'Water is overflowing from the drip tray and accumulating on the corridor floor, creating a slipping hazard.',
        location: 'Block A',
        priority: AppConstants.priorityMedium,
        status: AppConstants.statusResolved,
        assignedTo: 'Maintenance Staff',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
        resolvedAt: now.subtract(const Duration(days: 1)),
      ),
      ComplaintModel(
        complaintId: 'CMP-2026-0004',
        studentUid: 'demo-student-001',
        studentId: 'CS-2024-042',
        studentName: 'Rahul Sharma',
        department: 'Computer Science',
        category: 'Furniture',
        title: 'Broken desk chair in Classroom 204',
        description:
            'The wooden backrest of chair row 3, seat 4 is broken and unstable.',
        location: 'Classroom',
        priority: AppConstants.priorityLow,
        status: AppConstants.statusClosed,
        assignedTo: 'Maintenance Staff',
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now.subtract(const Duration(days: 7)),
        resolvedAt: now.subtract(const Duration(days: 8)),
      ),
    ]);

    // Initial comments
    _comments.addAll([
      {
        'complaintId': 'CMP-2026-0001',
        'userId': 'demo-staff-001',
        'userName': 'Prof. Anjali Verma',
        'comment':
            'Technician has been notified. Servicing team scheduled for 2:00 PM today.',
        'createdAt': now.subtract(const Duration(hours: 5)),
      },
      {
        'complaintId': 'CMP-2026-0003',
        'userId': 'maintenance-001',
        'userName': 'Maintenance Team',
        'comment': 'Drain pipe replaced and valve resealed. Issue resolved.',
        'createdAt': now.subtract(const Duration(days: 1)),
      },
    ]);

    // Initial feedback
    _feedbacks.add(
      FeedbackModel(
        complaintId: 'CMP-2026-0003',
        studentId: 'CS-2024-042',
        rating: 5,
        comment: 'Resolved quickly within 24 hours. Great work by campus maintenance team!',
        createdAt: now.subtract(const Duration(hours: 20)),
      ),
    );

    // Initial notifications
    _notifications.addAll([
      NotificationModel(
        id: 'notif-001',
        userId: 'demo-student-001',
        title: 'Complaint In Progress',
        message:
            'Your complaint CMP-2026-0001 has been assigned to Prof. Anjali Verma and is In Progress.',
        complaintId: 'CMP-2026-0001',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: 'notif-002',
        userId: 'demo-student-001',
        title: 'Complaint Resolved',
        message:
            'Your complaint CMP-2026-0003 (Water cooler leaking) has been marked as Resolved. Please submit your feedback!',
        complaintId: 'CMP-2026-0003',
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 'notif-003',
        userId: 'demo-student-001',
        title: 'Complaint Received',
        message:
            'Your complaint CMP-2026-0002 has been successfully registered and is Under Review.',
        complaintId: 'CMP-2026-0002',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 18)),
      ),
    ]);
  }

  // --- Dynamic Categories, Departments, Locations ---
  List<String> get categories => List.unmodifiable(_categories);
  List<String> get departments => List.unmodifiable(_departments);
  List<String> get locations => List.unmodifiable(_locations);

  void addCategory(String category) {
    if (!_categories.contains(category)) _categories.add(category);
  }

  void removeCategory(String category) {
    _categories.remove(category);
  }

  void addDepartment(String department) {
    if (!_departments.contains(department)) _departments.add(department);
  }

  void removeDepartment(String department) {
    _departments.remove(department);
  }

  void addLocation(String location) {
    if (!_locations.contains(location)) _locations.add(location);
  }

  void removeLocation(String location) {
    _locations.remove(location);
  }

  // --- Complaint Queries ---

  /// Generate next sequential complaint ID
  String generateNextId() {
    final year = DateTime.now().year;
    final id = 'CMP-$year-${_complaintCounter.toString().padLeft(4, '0')}';
    _complaintCounter++;
    return id;
  }

  /// All complaints (for Administrator)
  Future<List<ComplaintModel>> getAllComplaints() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_complaints)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Student complaints
  Future<List<ComplaintModel>> getStudentComplaints(String studentUid) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _complaints
        .where((c) =>
            c.studentUid == studentUid ||
            studentUid == 'demo-student-001' ||
            c.studentUid == 'demo-student-001' ||
            studentUid.isEmpty)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Staff complaints (assigned to staff member or general department)
  Future<List<ComplaintModel>> getStaffComplaints({
    String? staffName,
    String? department,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _complaints.where((c) {
      if (staffName != null && c.assignedTo != null) {
        if (c.assignedTo!.toLowerCase().contains(staffName.toLowerCase()) ||
            staffName.toLowerCase().contains(c.assignedTo!.toLowerCase())) {
          return true;
        }
      }
      if (department != null &&
          c.department.toLowerCase() == department.toLowerCase()) {
        return true;
      }
      // In demo mode for Prof. Anjali Verma, return all assigned/active grievances
      return c.assignedTo != null;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Stats for Student
  Future<Map<String, int>> getStudentStats(String studentUid) async {
    final list = await getStudentComplaints(studentUid);
    return {
      'total': list.length,
      'pending': list.where((c) => c.isPending).length,
      'inProgress': list.where((c) => c.isInProgress).length,
      'resolved': list.where((c) => c.isResolved || c.isClosed).length,
    };
  }

  /// Stats for Staff
  Future<Map<String, int>> getStaffStats(String staffName) async {
    final list = await getStaffComplaints(staffName: staffName);
    return {
      'total': list.length,
      'pending': list.where((c) => c.isPending).length,
      'inProgress': list.where((c) => c.isInProgress).length,
      'resolved': list.where((c) => c.isResolved || c.isClosed).length,
      'urgent': list.where((c) => c.priority == AppConstants.priorityUrgent).length,
    };
  }

  /// Stats for Administrator
  Future<Map<String, dynamic>> getAdminStats() async {
    final list = _complaints;
    int total = list.length;
    int pending = list.where((c) => c.isPending).length;
    int inProgress = list.where((c) => c.isInProgress).length;
    int resolved = list.where((c) => c.isResolved).length;
    int closed = list.where((c) => c.isClosed).length;
    int urgent = list.where((c) => c.priority == AppConstants.priorityUrgent).length;

    // Category breakdown
    final Map<String, int> byCategory = {};
    for (final c in list) {
      byCategory[c.category] = (byCategory[c.category] ?? 0) + 1;
    }

    // Department breakdown
    final Map<String, int> byDepartment = {};
    for (final c in list) {
      byDepartment[c.department] = (byDepartment[c.department] ?? 0) + 1;
    }

    // Status breakdown
    final Map<String, int> byStatus = {};
    for (final c in list) {
      byStatus[c.status] = (byStatus[c.status] ?? 0) + 1;
    }

    return {
      'total': total,
      'pending': pending,
      'inProgress': inProgress,
      'resolved': resolved,
      'closed': closed,
      'urgent': urgent,
      'byCategory': byCategory,
      'byDepartment': byDepartment,
      'byStatus': byStatus,
    };
  }

  // --- Complaint Mutations ---

  /// Submit new complaint
  Future<ComplaintModel> submitComplaint(ComplaintModel complaint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _complaints.insert(0, complaint);

    _notifications.insert(
      0,
      NotificationModel(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        userId: complaint.studentUid,
        title: 'Complaint Submitted',
        message:
            'Your complaint ${complaint.complaintId} (${complaint.title}) was submitted successfully.',
        complaintId: complaint.complaintId,
        isRead: false,
        createdAt: DateTime.now(),
      ),
    );
    return complaint;
  }

  /// Update complaint status
  Future<void> updateStatus({
    required String complaintId,
    required String newStatus,
    String? comment,
    String? updatedBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _complaints.indexWhere((c) => c.complaintId == complaintId);
    if (index != -1) {
      final current = _complaints[index];
      final isResolved = newStatus == AppConstants.statusResolved;
      _complaints[index] = current.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        resolvedAt: isResolved ? DateTime.now() : current.resolvedAt,
      );

      // Add status change comment if provided
      if (comment != null && comment.trim().isNotEmpty) {
        _comments.add({
          'complaintId': complaintId,
          'userId': updatedBy ?? 'staff',
          'userName': updatedBy ?? 'Staff',
          'comment': comment.trim(),
          'createdAt': DateTime.now(),
        });
      }

      // Add notification for student
      _notifications.insert(
        0,
        NotificationModel(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          userId: current.studentUid,
          title: 'Status: $newStatus',
          message:
              'Complaint $complaintId status updated to "$newStatus" by ${updatedBy ?? "college staff"}.',
          complaintId: complaintId,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  /// Assign complaint to staff
  Future<void> assignComplaint({
    required String complaintId,
    required String staffName,
    String? priority,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _complaints.indexWhere((c) => c.complaintId == complaintId);
    if (index != -1) {
      final current = _complaints[index];
      _complaints[index] = current.copyWith(
        assignedTo: staffName,
        status: AppConstants.statusAssigned,
        priority: priority ?? current.priority,
        updatedAt: DateTime.now(),
      );

      _notifications.insert(
        0,
        NotificationModel(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          userId: current.studentUid,
          title: 'Complaint Assigned',
          message:
              'Your complaint $complaintId has been assigned to $staffName.',
          complaintId: complaintId,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  /// Delete inappropriate complaint (Administrator action)
  Future<void> deleteComplaint(String complaintId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _complaints.removeWhere((c) => c.complaintId == complaintId);
    _comments.removeWhere((c) => c['complaintId'] == complaintId);
    _feedbacks.removeWhere((f) => f.complaintId == complaintId);
  }

  // --- Comments & Feedback ---

  List<Map<String, dynamic>> getComments(String complaintId) {
    return _comments
        .where((c) => c['complaintId'] == complaintId)
        .toList()
      ..sort((a, b) => (a['createdAt'] as DateTime).compareTo(b['createdAt'] as DateTime));
  }

  void addComment({
    required String complaintId,
    required String userId,
    required String userName,
    required String comment,
  }) {
    _comments.add({
      'complaintId': complaintId,
      'userId': userId,
      'userName': userName,
      'comment': comment.trim(),
      'createdAt': DateTime.now(),
    });
  }

  FeedbackModel? getFeedback(String complaintId) {
    try {
      return _feedbacks.firstWhere((f) => f.complaintId == complaintId);
    } catch (_) {
      return null;
    }
  }

  void submitFeedback(FeedbackModel feedback) {
    _feedbacks.removeWhere((f) => f.complaintId == feedback.complaintId);
    _feedbacks.add(feedback);
  }

  // --- Notifications ---

  Future<List<NotificationModel>> getNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _notifications
        .where((n) => n.userId == userId || userId == 'demo-student-001')
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> markNotificationAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notif = _notifications[index];
      _notifications[index] = NotificationModel(
        id: notif.id,
        userId: notif.userId,
        title: notif.title,
        message: notif.message,
        complaintId: notif.complaintId,
        isRead: true,
        createdAt: notif.createdAt,
      );
    }
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    for (int i = 0; i < _notifications.length; i++) {
      if (_notifications[i].userId == userId || userId == 'demo-student-001') {
        final notif = _notifications[i];
        _notifications[i] = NotificationModel(
          id: notif.id,
          userId: notif.userId,
          title: notif.title,
          message: notif.message,
          complaintId: notif.complaintId,
          isRead: true,
          createdAt: notif.createdAt,
        );
      }
    }
  }
}
