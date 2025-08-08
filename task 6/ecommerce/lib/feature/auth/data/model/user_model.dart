import '../../domain/entites/user.dart';

class UserModel extends User {
  UserModel({
    required super.password,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'name': name,
      'email': email,
    };
  }
}
