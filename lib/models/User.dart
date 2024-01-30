// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String name;
  String email;
  // int isRoot;
  // int mustChangePassword;
  // DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    // required this.isRoot,
    // required this.mustChangePassword,
    // required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        // isRoot: json["is_root"],
        // mustChangePassword: json["must_change_password"],
        // createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        // "is_root": isRoot,
        // "must_change_password": mustChangePassword,
        // "created_at": createdAt.toIso8601String(),
      };
}
