// ============================================================
// FILE: lib/models/user_model.dart
// PURPOSE: Defines the User data model.
//
// This model represents a user in the CCMS app.
// It maps directly to the Firestore 'users' collection.
// Includes factory methods to convert to/from JSON (Map).
// ============================================================

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role; // 'student', 'staff', 'admin'
  final String department;
  final String? studentId;
  final String? year;
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
    this.year,
    this.profileImage,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Creates a UserModel from a Firestore document (Map)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'student',
      department: map['department'] ?? '',
      studentId: map['studentId'],
      year: map['year'],
      profileImage: map['profileImage'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  /// Converts UserModel to a Map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'department': department,
      'studentId': studentId,
      'year': year,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Creates a copy of this UserModel with some fields changed
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? department,
    String? studentId,
    String? year,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      department: department ?? this.department,
      studentId: studentId ?? this.studentId,
      year: year ?? this.year,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if the user is a student
  bool get isStudent => role == 'student';

  /// Check if the user is staff
  bool get isStaff => role == 'staff';

  /// Check if the user is an administrator
  bool get isAdmin => role == 'admin';

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, role: $role)';
  }
}
