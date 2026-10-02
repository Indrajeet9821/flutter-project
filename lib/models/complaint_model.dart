import '../utils/constants.dart';

/// Complaint Model representing a student grievance in CCMS
class ComplaintModel {
  final String complaintId; // e.g. CMP-2026-0001
  final String studentUid; // Firebase UID
  final String studentId; // Student Roll Number
  final String studentName;
  final String department;
  final String category;
  final String title;
  final String description;
  final String location;
  final String priority; // Low, Medium, High, Urgent
  final String status; // Submitted, Under Review, Assigned, In Progress, etc.
  final String? assignedTo; // Staff Name or Role
  final String? imageUrl;
  final String? additionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;

  ComplaintModel({
    required this.complaintId,
    required this.studentUid,
    required this.studentId,
    required this.studentName,
    required this.department,
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    this.priority = AppConstants.priorityMedium,
    this.status = AppConstants.statusSubmitted,
    this.assignedTo,
    this.imageUrl,
    this.additionalInfo,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
  });

  /// Factory constructor to create ComplaintModel from Firestore Map
  factory ComplaintModel.fromMap(Map<String, dynamic> map, String id) {
    return ComplaintModel(
      complaintId: map['complaintId'] ?? id,
      studentUid: map['studentUid'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      department: map['department'] ?? '',
      category: map['category'] ?? 'Other',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      priority: map['priority'] ?? AppConstants.priorityMedium,
      status: map['status'] ?? AppConstants.statusSubmitted,
      assignedTo: map['assignedTo'],
      imageUrl: map['imageUrl'],
      additionalInfo: map['additionalInfo'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : DateTime.now(),
      resolvedAt: map['resolvedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resolvedAt'])
          : null,
    );
  }

  /// Converts ComplaintModel to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'complaintId': complaintId,
      'studentUid': studentUid,
      'studentId': studentId,
      'studentName': studentName,
      'department': department,
      'category': category,
      'title': title,
      'description': description,
      'location': location,
      'priority': priority,
      'status': status,
      'assignedTo': assignedTo,
      'imageUrl': imageUrl,
      'additionalInfo': additionalInfo,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'resolvedAt': resolvedAt?.millisecondsSinceEpoch,
    };
  }

  /// CopyWith helper for state updates
  ComplaintModel copyWith({
    String? complaintId,
    String? studentUid,
    String? studentId,
    String? studentName,
    String? department,
    String? category,
    String? title,
    String? description,
    String? location,
    String? priority,
    String? status,
    String? assignedTo,
    String? imageUrl,
    String? additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  }) {
    return ComplaintModel(
      complaintId: complaintId ?? this.complaintId,
      studentUid: studentUid ?? this.studentUid,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      department: department ?? this.department,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  bool get isResolved => status == AppConstants.statusResolved;
  bool get isClosed => status == AppConstants.statusClosed;
  bool get isPending =>
      status == AppConstants.statusSubmitted ||
      status == AppConstants.statusUnderReview ||
      status == AppConstants.statusAssigned;
  bool get isInProgress => status == AppConstants.statusInProgress;
}
