/// Student Feedback Model for post-resolution ratings
class FeedbackModel {
  final String complaintId;
  final String studentId;
  final int rating; // 1 to 5 stars
  final String comment;
  final DateTime createdAt;

  FeedbackModel({
    required this.complaintId,
    required this.studentId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      complaintId: map['complaintId'] ?? '',
      studentId: map['studentId'] ?? '',
      rating: map['rating'] ?? 5,
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'complaintId': complaintId,
      'studentId': studentId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
