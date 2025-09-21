enum UserRole {
  student,
  teacher,
  admin,
}

class AppUser {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final Map<String, dynamic>? additionalData;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.lastLoginAt,
    this.additionalData,
  });

  // Convert UserRole enum to string
  static String roleToString(UserRole role) {
    return role.toString().split('.').last;
  }

  // Convert string to UserRole enum
  static UserRole roleFromString(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'teacher':
        return UserRole.teacher;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.student; // default to student
    }
  }

  // Convert to Firestore document format
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': roleToString(role),
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'additionalData': additionalData ?? {},
    };
  }

  // Create AppUser from Firestore document
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: roleFromString(map['role'] ?? 'student'),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLoginAt: DateTime.parse(map['lastLoginAt'] ?? DateTime.now().toIso8601String()),
      additionalData: map['additionalData'],
    );
  }

  // Create a copy of the user with updated fields
  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    UserRole? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? additionalData,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, name: $name, role: ${roleToString(role)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.uid == uid;
  }

  @override
  int get hashCode {
    return uid.hashCode;
  }
}