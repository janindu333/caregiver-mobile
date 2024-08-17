import '../../domain/entities/user_entity.dart';

class UserModel extends AppUser {
  UserModel({
    required String id,
    required String name,
    required String email,
    required String role,
  }) : super(id: id, name: name, email: email, role: role);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
