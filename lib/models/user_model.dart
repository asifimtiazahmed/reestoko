import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isPremium;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isPremium = false,
  });

  // Empty user constant
  static const empty = User(id: '', name: '', email: '');

  // CopyWith method for immutability
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    bool? isPremium,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'isPremium': isPremium,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  // Dummy data
  static const User dummy1 = User(
    id: 'user_123',
    name: 'John Doe',
    email: 'john.doe@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?u=user_123',
    isPremium: true,
  );

  static const List<User> dummyUsers = [
    dummy1,
    User(
      id: 'user_456',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?u=user_456',
    ),
     User(
      id: 'user_789',
      name: 'Bob Johnson',
      email: 'bob.j@example.com',
    ),
  ];

  @override
  List<Object?> get props => [id, name, email, avatarUrl, isPremium];
}
