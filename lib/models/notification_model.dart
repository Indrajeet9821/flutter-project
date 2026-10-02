// ============================================================
// FILE: lib/models/notification_model.dart
// PURPOSE: Data model for notifications.
// ============================================================

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String? complaintId;
  bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.complaintId,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      complaintId: map['complaintId'],
      isRead: map['isRead'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'complaintId': complaintId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
