import 'package:flutter_test/flutter_test.dart';
import 'package:ccms/models/complaint_model.dart';
import 'package:ccms/providers/auth_provider.dart';
import 'package:ccms/providers/complaint_provider.dart';
import 'package:ccms/services/auth_service.dart';
import 'package:ccms/services/complaint_service.dart';
import 'package:ccms/utils/constants.dart';

void main() {
  group('CCMS Grievance Submission & Lifecycle Tests', () {
    late AuthService authService;
    late ComplaintService complaintService;
    late AuthProvider authProvider;
    late ComplaintProvider complaintProvider;

    setUp(() {
      authService = AuthService();
      complaintService = ComplaintService();
      authProvider = AuthProvider(authService: authService);
      complaintProvider = ComplaintProvider(service: complaintService);
    });

    test('All 3 user roles can login successfully', () async {
      // 1. Student Login
      final studentSuccess = await authProvider.login(
        emailOrStudentId: 'student@college.edu',
        password: 'password123',
      );
      expect(studentSuccess, isTrue);
      expect(authProvider.isStudent, isTrue);
      expect(authProvider.currentUser?.name, 'Rahul Sharma');

      // 2. Staff Login
      final staffSuccess = await authProvider.login(
        emailOrStudentId: 'staff@college.edu',
        password: 'password123',
      );
      expect(staffSuccess, isTrue);
      expect(authProvider.isStaff, isTrue);
      expect(authProvider.currentUser?.name, 'Prof. Anjali Verma');

      // 3. Admin Login
      final adminSuccess = await authProvider.login(
        emailOrStudentId: 'admin@college.edu',
        password: 'password123',
      );
      expect(adminSuccess, isTrue);
      expect(authProvider.isAdmin, isTrue);
      expect(authProvider.currentUser?.name, contains('Dr. Suresh Kumar'));
    });

    test('New complaint is submitted and immediately visible at top of list', () async {
      // Load initial dashboard for student
      await complaintProvider.loadStudentDashboard('demo-student-001');
      final initialCount = complaintProvider.studentComplaints.length;
      expect(initialCount, equals(4));

      // Simulate active filter before submission (e.g. user previously tapped a filter)
      complaintProvider.setStatusFilter('In Progress');
      expect(complaintProvider.selectedStatusFilter, equals('In Progress'));

      // Create a brand new complaint
      final newComplaintId = complaintProvider.generateNextComplaintId();
      final newComplaint = ComplaintModel(
        complaintId: newComplaintId,
        studentUid: 'demo-student-001',
        studentId: 'CS-2024-042',
        studentName: 'Rahul Sharma',
        department: 'Computer Science',
        category: 'Internet/Wi-Fi',
        title: 'New High Priority Wi-Fi Failure',
        description: 'No internet in Block C 3rd floor seminar hall during presentation.',
        location: 'Block C',
        priority: AppConstants.priorityUrgent,
        status: AppConstants.statusSubmitted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await complaintProvider.submitNewComplaint(newComplaint);
      expect(success, isTrue);

      // Verify filters are automatically cleared on submit
      expect(complaintProvider.selectedStatusFilter, equals('All'));
      expect(complaintProvider.searchQuery, isEmpty);

      // Verify complaint list count incremented
      expect(complaintProvider.studentComplaints.length, equals(initialCount + 1));

      // Verify the new complaint is at the very top (index 0)
      expect(complaintProvider.studentComplaints.first.complaintId, equals(newComplaintId));
      expect(complaintProvider.studentComplaints.first.title, equals('New High Priority Wi-Fi Failure'));

      // Verify filteredComplaints also contains the new complaint
      expect(complaintProvider.filteredComplaints.first.complaintId, equals(newComplaintId));

      // Verify that if 'Pending' filter is selected, the new complaint remains visible!
      complaintProvider.setStatusFilter('Pending');
      final pendingComplaints = complaintProvider.filteredComplaints;
      expect(pendingComplaints.any((c) => c.complaintId == newComplaintId), isTrue);
    });
  });
}
