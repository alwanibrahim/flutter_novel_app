// To parse this JSON data, do
//
//     final data = datafromJson(jsonString);

import 'dart:convert';

Data datafromJson(String str) => Data.fromJson(json.decode(str));

String datatoJson(Data data) => json.encode(data.toJson());

class Data {
  final bool status;
  final List<AuthorModel> data;

  Data({
    required this.status,
    required this.data,
  });

  Data copyWith({
    bool? status,
    List<AuthorModel>? data,
  }) =>
      Data(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        data: List<AuthorModel>.from(json["data"].map((x) => AuthorModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AuthorModel {
  final int id;
  final String name;
  final String bio;
  final String profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  AuthorModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  AuthorModel copyWith({
    int? id,
    String? name,
    String? bio,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      AuthorModel(
        id: id ?? this.id,
        name: name ?? this.name,
        bio: bio ?? this.bio,
        profilePicture: profilePicture ?? this.profilePicture,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory AuthorModel.fromJson(Map<String, dynamic> json) => AuthorModel(
        id: json["id"],
        name: json["name"],
        bio: json["bio"],
        profilePicture: json["profile_picture"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "bio": bio,
        "profile_picture": profilePicture,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
