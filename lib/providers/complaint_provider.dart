import 'package:flutter/material.dart';
import '../models/complaint_model.dart';
import '../models/notification_model.dart';
import '../models/feedback_model.dart';
import '../services/complaint_service.dart';

/// ComplaintProvider manages complaint state, multi-role querying,
/// status transitions, comments, feedback, and notifications.
class ComplaintProvider extends ChangeNotifier {
  final ComplaintService _service;

  // Active state lists
  List<ComplaintModel> _studentComplaints = [];
  List<ComplaintModel> _staffComplaints = [];
  List<ComplaintModel> _allComplaints = [];

  Map<String, int> _studentStats = {
    'total': 0,
    'pending': 0,
    'inProgress': 0,
    'resolved': 0,
  };

  Map<String, int> _staffStats = {
    'total': 0,
    'pending': 0,
    'inProgress': 0,
    'resolved': 0,
    'urgent': 0,
  };

  Map<String, dynamic> _adminStats = {
    'total': 0,
    'pending': 0,
    'inProgress': 0,
    'resolved': 0,
    'closed': 0,
    'urgent': 0,
    'byCategory': <String, int>{},
    'byDepartment': <String, int>{},
    'byStatus': <String, int>{},
  };

  List<NotificationModel> _notifications = [];

  bool _isLoading = false;
  String? _errorMessage;

  // Filters
  String _searchQuery = '';
  String _selectedStatusFilter = 'All';
  String _selectedPriorityFilter = 'All';
  String _selectedCategoryFilter = 'All';
  String _selectedDepartmentFilter = 'All';

  ComplaintProvider({ComplaintService? service})
      : _service = service ?? ComplaintService();

  // Getters
  List<ComplaintModel> get studentComplaints => _studentComplaints;
  List<ComplaintModel> get staffComplaints => _staffComplaints;
  List<ComplaintModel> get allComplaints => _allComplaints;

  Map<String, int> get studentStats => _studentStats;
  Map<String, int> get staffStats => _staffStats;
  Map<String, dynamic> get adminStats => _adminStats;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get selectedPriorityFilter => _selectedPriorityFilter;
  String get selectedCategoryFilter => _selectedCategoryFilter;
  String get selectedDepartmentFilter => _selectedDepartmentFilter;

  List<String> get categories => _service.categories;
  List<String> get departments => _service.departments;
  List<String> get locations => _service.locations;

  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  String generateNextComplaintId() => _service.generateNextId();

  String? _currentStudentUid;

  // --- Student Dashboard Loader ---
  Future<void> loadStudentDashboard(String studentUid) async {
    _currentStudentUid = studentUid;
    _isLoading = true;
    notifyListeners();

    try {
      final complaints = await _service.getStudentComplaints(studentUid);
      final stats = await _service.getStudentStats(studentUid);
      final notifs = await _service.getNotifications(studentUid);

      _studentComplaints = complaints;
      _studentStats = stats;
      _notifications = notifs;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // --- Staff Dashboard Loader ---
  Future<void> loadStaffDashboard({String? staffName, String? department}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final complaints = await _service.getStaffComplaints(
        staffName: staffName,
        department: department,
      );
      final stats = await _service.getStaffStats(staffName ?? 'Staff');
      final notifs = await _service.getNotifications('demo-staff-001');

      _staffComplaints = complaints;
      _staffStats = stats;
      _notifications = notifs;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // --- Admin Dashboard Loader ---
  Future<void> loadAdminDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      final complaints = await _service.getAllComplaints();
      final stats = await _service.getAdminStats();
      final notifs = await _service.getNotifications('demo-admin-001');

      _allComplaints = complaints;
      _adminStats = stats;
      _notifications = notifs;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // --- Submit Complaint ---
  Future<bool> submitNewComplaint(ComplaintModel complaint) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentStudentUid = complaint.studentUid;
      await _service.submitComplaint(complaint);
      _studentComplaints = await _service.getStudentComplaints(complaint.studentUid);
      _studentStats = await _service.getStudentStats(complaint.studentUid);
      _allComplaints = await _service.getAllComplaints();
      _adminStats = await _service.getAdminStats();
      _staffComplaints = await _service.getStaffComplaints();
      _notifications = await _service.getNotifications(complaint.studentUid);

      // Auto clear any active filters so the new complaint is directly visible!
      _searchQuery = '';
      _selectedStatusFilter = 'All';
      _selectedPriorityFilter = 'All';
      _selectedCategoryFilter = 'All';
      _selectedDepartmentFilter = 'All';

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // --- Status & Assignment Mutations ---
  Future<void> updateComplaintStatus({
    required String complaintId,
    required String newStatus,
    String? comment,
    String? updatedBy,
    String? activeRole,
  }) async {
    await _service.updateStatus(
      complaintId: complaintId,
      newStatus: newStatus,
      comment: comment,
      updatedBy: updatedBy,
    );

    final activeStudent = _currentStudentUid ?? 'demo-student-001';

    // Refresh active views
    _allComplaints = await _service.getAllComplaints();
    _adminStats = await _service.getAdminStats();
    _staffComplaints = await _service.getStaffComplaints(staffName: updatedBy);
    _staffStats = await _service.getStaffStats(updatedBy ?? 'Staff');
    _studentComplaints = await _service.getStudentComplaints(activeStudent);
    _studentStats = await _service.getStudentStats(activeStudent);
    notifyListeners();
  }

  Future<void> assignComplaint({
    required String complaintId,
    required String staffName,
    String? priority,
  }) async {
    await _service.assignComplaint(
      complaintId: complaintId,
      staffName: staffName,
      priority: priority,
    );
    final activeStudent = _currentStudentUid ?? 'demo-student-001';
    _allComplaints = await _service.getAllComplaints();
    _adminStats = await _service.getAdminStats();
    _staffComplaints = await _service.getStaffComplaints();
    _studentComplaints = await _service.getStudentComplaints(activeStudent);
    _studentStats = await _service.getStudentStats(activeStudent);
    notifyListeners();
  }

  Future<void> deleteComplaint(String complaintId) async {
    await _service.deleteComplaint(complaintId);
    final activeStudent = _currentStudentUid ?? 'demo-student-001';
    _allComplaints = await _service.getAllComplaints();
    _adminStats = await _service.getAdminStats();
    _studentComplaints = await _service.getStudentComplaints(activeStudent);
    _studentStats = await _service.getStudentStats(activeStudent);
    notifyListeners();
  }

  // --- Comments & Feedback ---
  List<Map<String, dynamic>> getComments(String complaintId) {
    return _service.getComments(complaintId);
  }

  void addComment({
    required String complaintId,
    required String userId,
    required String userName,
    required String comment,
  }) {
    _service.addComment(
      complaintId: complaintId,
      userId: userId,
      userName: userName,
      comment: comment,
    );
    notifyListeners();
  }

  FeedbackModel? getFeedback(String complaintId) {
    return _service.getFeedback(complaintId);
  }

  void submitFeedback(FeedbackModel feedback) {
    _service.submitFeedback(feedback);
    notifyListeners();
  }

  // --- Filter Helpers ---
  List<ComplaintModel> get filteredComplaints {
    return _studentComplaints.where((c) {
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.complaintId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.location.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatusFilter == 'All' ||
          (_selectedStatusFilter == 'Pending'
              ? c.isPending
              : c.status == _selectedStatusFilter);

      final matchesPriority = _selectedPriorityFilter == 'All' ||
          c.priority == _selectedPriorityFilter;

      final matchesCategory = _selectedCategoryFilter == 'All' ||
          c.category == _selectedCategoryFilter;

      return matchesSearch && matchesStatus && matchesPriority && matchesCategory;
    }).toList();
  }

  List<ComplaintModel> get filteredAdminComplaints {
    return _allComplaints.where((c) {
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.complaintId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.studentName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.studentId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.location.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatusFilter == 'All' ||
          c.status == _selectedStatusFilter;

      final matchesPriority = _selectedPriorityFilter == 'All' ||
          c.priority == _selectedPriorityFilter;

      final matchesCategory = _selectedCategoryFilter == 'All' ||
          c.category == _selectedCategoryFilter;

      final matchesDept = _selectedDepartmentFilter == 'All' ||
          c.department == _selectedDepartmentFilter;

      return matchesSearch &&
          matchesStatus &&
          matchesPriority &&
          matchesCategory &&
          matchesDept;
    }).toList();
  }

  List<ComplaintModel> get filteredStaffComplaints {
    return _staffComplaints.where((c) {
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.complaintId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatusFilter == 'All' ||
          c.status == _selectedStatusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(String priority) {
    _selectedPriorityFilter = priority;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void setDepartmentFilter(String dept) {
    _selectedDepartmentFilter = dept;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedStatusFilter = 'All';
    _selectedPriorityFilter = 'All';
    _selectedCategoryFilter = 'All';
    _selectedDepartmentFilter = 'All';
    notifyListeners();
  }

  // --- Dynamic Category, Department, Location Management ---
  void addCategory(String cat) {
    _service.addCategory(cat);
    notifyListeners();
  }

  void removeCategory(String cat) {
    _service.removeCategory(cat);
    notifyListeners();
  }

  void addDepartment(String dept) {
    _service.addDepartment(dept);
    notifyListeners();
  }

  void removeDepartment(String dept) {
    _service.removeDepartment(dept);
    notifyListeners();
  }

  void addLocation(String loc) {
    _service.addLocation(loc);
    notifyListeners();
  }

  void removeLocation(String loc) {
    _service.removeLocation(loc);
    notifyListeners();
  }

  // --- Notifications ---
  Future<void> markNotificationAsRead(String id) async {
    await _service.markNotificationAsRead(id);
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
      notifyListeners();
    }
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    await _service.markAllNotificationsAsRead(userId);
    for (int i = 0; i < _notifications.length; i++) {
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
    notifyListeners();
  }
}
