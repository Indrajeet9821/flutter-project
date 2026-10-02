/// User Model representing students, teachers/staff, and administrators
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role; // Student, Teacher/Staff, Administrator
  final String department;
  final String? studentId; // Only applicable for students
  final String? profileImage;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    this.studentId,
    this.profileImage,
    required this.createdAt,
  });

  /// Factory constructor to create UserModel from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'Student',
      department: map['department'] ?? '',
      studentId: map['studentId'],
      profileImage: map['profileImage'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  /// Converts UserModel to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'department': department,
      'studentId': studentId,
      'profileImage': profileImage,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Helper getters for role checks
  bool get isStudent => role == 'Student';
  bool get isStaff => role == 'Teacher/Staff';
  bool get isAdmin => role == 'Administrator';
}
