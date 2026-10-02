// ============================================================
// FILE: lib/models/complaint_model.dart
// PURPOSE: Data model for complaints.
// ============================================================

class ComplaintModel {
  final String complaintId;
  final String studentId;
  final String studentName;
  final String studentDepartment;
  final String studentYear;
  final String category;
  final String title;
  final String description;
  final String location;
  final String priority;
  String status;
  final String? assignedTo;
  final String? assignedToName;
  final String? imageUrl;
  final DateTime createdAt;
  DateTime updatedAt;
  final DateTime? resolvedAt;
  final List<StatusChange> statusHistory;

  ComplaintModel({
    required this.complaintId,
    required this.studentId,
    required this.studentName,
    this.studentDepartment = '',
    this.studentYear = '',
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.priority,
    this.status = 'Submitted',
    this.assignedTo,
    this.assignedToName,
    this.imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.resolvedAt,
    List<StatusChange>? statusHistory,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        statusHistory = statusHistory ??
            [
              StatusChange(
                status: 'Submitted',
                changedAt: createdAt ?? DateTime.now(),
                changedBy: studentName,
                note: 'Complaint submitted',
              ),
            ];

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      complaintId: map['complaintId'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      studentDepartment: map['studentDepartment'] ?? '',
      studentYear: map['studentYear'] ?? '',
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      priority: map['priority'] ?? 'Medium',
      status: map['status'] ?? 'Submitted',
      assignedTo: map['assignedTo'],
      assignedToName: map['assignedToName'],
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      resolvedAt: map['resolvedAt'] != null
          ? DateTime.parse(map['resolvedAt'])
          : null,
      statusHistory: map['statusHistory'] != null
          ? (map['statusHistory'] as List)
              .map((s) => StatusChange.fromMap(s))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'complaintId': complaintId,
      'studentId': studentId,
      'studentName': studentName,
      'studentDepartment': studentDepartment,
      'studentYear': studentYear,
      'category': category,
      'title': title,
      'description': description,
      'location': location,
      'priority': priority,
      'status': status,
      'assignedTo': assignedTo,
      'assignedToName': assignedToName,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'statusHistory': statusHistory.map((s) => s.toMap()).toList(),
    };
  }

  ComplaintModel copyWith({
    String? complaintId,
    String? studentId,
    String? studentName,
    String? studentDepartment,
    String? studentYear,
    String? category,
    String? title,
    String? description,
    String? location,
    String? priority,
    String? status,
    String? assignedTo,
    String? assignedToName,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    List<StatusChange>? statusHistory,
  }) {
    return ComplaintModel(
      complaintId: complaintId ?? this.complaintId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentDepartment: studentDepartment ?? this.studentDepartment,
      studentYear: studentYear ?? this.studentYear,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedToName: assignedToName ?? this.assignedToName,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }
}

class StatusChange {
  final String status;
  final DateTime changedAt;
  final String changedBy;
  final String? note;

  StatusChange({
    required this.status,
    required this.changedAt,
    required this.changedBy,
    this.note,
  });

  factory StatusChange.fromMap(Map<String, dynamic> map) {
    return StatusChange(
      status: map['status'] ?? '',
      changedAt: map['changedAt'] != null
          ? DateTime.parse(map['changedAt'])
          : DateTime.now(),
      changedBy: map['changedBy'] ?? '',
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'changedAt': changedAt.toIso8601String(),
      'changedBy': changedBy,
      'note': note,
    };
  }
}

class CommentModel {
  final String id;
  final String complaintId;
  final String userId;
  final String userName;
  final String userRole;
  final String comment;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.complaintId,
    required this.userId,
    required this.userName,
    this.userRole = 'student',
    required this.comment,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      complaintId: map['complaintId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userRole: map['userRole'] ?? 'student',
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'complaintId': complaintId,
      'userId': userId,
      'userName': userName,
      'userRole': userRole,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
