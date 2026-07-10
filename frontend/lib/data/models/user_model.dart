/// Represents an authenticated user returned from the API.
///
/// Adjust field names to match your API's actual JSON response.
/// Example response from POST /login:
/// {
///   "id": "123",
///   "name": "Jane Doe",
///   "email": "jane@example.com",
///   "token": "eyJhbGciOi..."
///   "token": "eyJhbGciOi...",
///   "role": "user"
/// }
class UserModel {
  final String id;
  final String name;
  final String email;
  final String token;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.role = 'user',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'token': token,
    'role': role,
  };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, email: $email, name: $name, role: $role)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
