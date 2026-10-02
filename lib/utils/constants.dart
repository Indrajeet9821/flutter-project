// ============================================================
// FILE: lib/utils/constants.dart
// PURPOSE: Stores all constant values used across the app.
//
// This file contains:
// - App name and version
// - Complaint categories
// - Priority levels
// - Complaint statuses
// - Departments
// - Locations
// - Staff roles for assignment
// ============================================================

class AppConstants {
  // ─── App Info ───
  static const String appName = 'College Complaint Management System';
  static const String appShortName = 'CCMS';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your voice matters. Report. Resolve. Improve.';

  // ─── User Roles ───
  static const String roleStudent = 'student';
  static const String roleStaff = 'staff';
  static const String roleAdmin = 'admin';

  // ─── Complaint Categories ───
  static const List<String> complaintCategories = [
    'Teacher/Faculty',
    'Classroom',
    'Laboratory',
    'Library',
    'Canteen',
    'Hostel',
    'Washroom',
    'Drinking Water',
    'Electricity',
    'Internet/Wi-Fi',
    'Computer/IT Equipment',
    'Projector/Smart Classroom',
    'Furniture',
    'Sports Facilities',
    'Transportation',
    'Campus Cleanliness',
    'Security',
    'Parking',
    'Examination',
    'Academic Issues',
    'Administrative Office',
    'Fees/Accounts',
    'Other',
  ];

  // ─── Priority Levels ───
  static const String priorityLow = 'Low';
  static const String priorityMedium = 'Medium';
  static const String priorityHigh = 'High';
  static const String priorityUrgent = 'Urgent';

  static const List<String> priorityLevels = [
    priorityLow,
    priorityMedium,
    priorityHigh,
    priorityUrgent,
  ];

  // ─── Complaint Statuses ───
  static const String statusSubmitted = 'Submitted';
  static const String statusUnderReview = 'Under Review';
  static const String statusAssigned = 'Assigned';
  static const String statusInProgress = 'In Progress';
  static const String statusWaitingForInfo = 'Waiting for Information';
  static const String statusResolved = 'Resolved';
  static const String statusClosed = 'Closed';
  static const String statusReopened = 'Reopened';
  static const String statusRejected = 'Rejected';

  static const List<String> complaintStatuses = [
    statusSubmitted,
    statusUnderReview,
    statusAssigned,
    statusInProgress,
    statusWaitingForInfo,
    statusResolved,
    statusClosed,
    statusReopened,
    statusRejected,
  ];

  // ─── Departments ───
  static const List<String> departments = [
    'Computer Science',
    'Information Technology',
    'Electronics',
    'Electrical',
    'Mechanical',
    'Civil',
    'Management',
    'Science',
    'Arts',
    'Other',
  ];

  // ─── Locations ───
  static const List<String> locations = [
    'Main Building',
    'Block A',
    'Block B',
    'Block C',
    'Computer Lab',
    'Physics Lab',
    'Chemistry Lab',
    'Library',
    'Canteen',
    'Hostel',
    'Playground',
    'Parking Area',
    'Classroom',
  ];

  // ─── Assignment Roles ───
  static const List<String> assignmentRoles = [
    'Teacher',
    'Lab Assistant',
    'Librarian',
    'Canteen Manager',
    'Hostel Staff',
    'IT Staff',
    'Maintenance Staff',
    'Security Staff',
    'Other',
  ];

  // ─── Years / Semesters ───
  static const List<String> years = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  static const List<String> semesters = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];
}
