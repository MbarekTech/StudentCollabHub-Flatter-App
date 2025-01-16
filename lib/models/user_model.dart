class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? name;
  final String? major;
  final List<String>? skills;
  final String? bio;
  final bool receiveNotifications;
  final List<String> favoriteProjects;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.name,
    this.major,
    this.skills,
    this.bio,
    this.receiveNotifications = true,
    this.favoriteProjects = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      major: map['major'],
      skills: List<String>.from(map['skills'] ?? []),
      bio: map['bio'],
      receiveNotifications: map['receiveNotifications'] ?? true,
      favoriteProjects: List<String>.from(map['favoriteProjects'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'major': major,
      'skills': skills,
      'bio': bio,
      'receiveNotifications': receiveNotifications,
      'favoriteProjects': favoriteProjects,
    };
  }
}