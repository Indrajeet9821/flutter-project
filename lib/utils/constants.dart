/// App-wide constants for College Complaint Management System (CCMS)
class AppConstants {
  // Application Information
  static const String appName = 'College Complaint Management System';
  static const String appShortName = 'CCMS';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Empowering Campus Voices, Resolving Concerns Efficiently';

  // User Roles
  static const String roleStudent = 'Student';
  static const String roleStaff = 'Teacher/Staff';
  static const String roleAdmin = 'Administrator';

  static const List<String> userRoles = [
    roleStudent,
    roleStaff,
    roleAdmin,
  ];

  // Complaint Priorities
  static const String priorityLow = 'Low';
  static const String priorityMedium = 'Medium';
  static const String priorityHigh = 'High';
  static const String priorityUrgent = 'Urgent';

  static const List<String> priorities = [
    priorityLow,
    priorityMedium,
    priorityHigh,
    priorityUrgent,
  ];

  // Complaint Statuses
  static const String statusSubmitted = 'Submitted';
  static const String statusUnderReview = 'Under Review';
  static const String statusAssigned = 'Assigned';
  static const String statusInProgress = 'In Progress';
  static const String statusWaitingForInfo = 'Waiting for Information';
  static const String statusResolved = 'Resolved';
  static const String statusClosed = 'Closed';
  static const String statusReopened = 'Reopened';
  static const String statusRejected = 'Rejected';

  static const List<String> statuses = [
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

  // 23 Default Complaint Categories
  static const List<String> defaultCategories = [
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

  // Default Departments
  static const List<String> defaultDepartments = [
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

  // Default Locations / Blocks
  static const List<String> defaultLocations = [
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

  // Responsible Staff Types (for Complaint Assignment)
  static const List<String> staffAssignmentTypes = [
    'Teacher',
    'Lab Assistant',
    'Librarian',
    'Canteen Manager',
    'Hostel Staff',
    'IT Staff',
    'Maintenance Staff',
    'Security Staff',
    'Other responsible staff',
  ];
}
