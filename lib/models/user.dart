class User {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String walletAddress;
  final String? bio;
  final String? avatarUrl;
  final List<String> skills;
  final double? hourlyRate;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.walletAddress,
    this.bio,
    this.avatarUrl,
    required this.skills,
    this.hourlyRate,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      role: json['role'],
      walletAddress: json['walletAddress'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      skills: List<String>.from(json['skills'] ?? []),
      hourlyRate: json['hourlyRate'] != null 
          ? double.parse(json['hourlyRate'].toString()) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'walletAddress': walletAddress,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'skills': skills,
      'hourlyRate': hourlyRate,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
