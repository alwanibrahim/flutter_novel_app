// To parse this JSON data, do
//
//     final comments = commentsfromJson(jsonString);

import 'dart:convert';

Comments commentsfromJson(String str) => Comments.fromJson(json.decode(str));

String commentsToMap(Comments data) => json.encode(data.toMap());

class Comments {
  final bool status;
  final List<CommentModel> data;

  Comments({
    required this.status,
    required this.data,
  });

  Comments copyWith({
    bool? status,
    List<CommentModel>? data,
  }) =>
      Comments(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        status: json["status"],
        data: List<CommentModel>.from(json["data"].map((x) => CommentModel.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class CommentModel {
  final int id;
  final int userId;
  final int reviewId;
  final String content;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  CommentModel({
    required this.id,
    required this.userId,
    required this.reviewId,
    required this.content,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  CommentModel copyWith({
    int? id,
    int? userId,
    int? reviewId,
    String? content,
    int? likesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) =>
      CommentModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        reviewId: reviewId ?? this.reviewId,
        content: content ?? this.content,
        likesCount: likesCount ?? this.likesCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        userId: json["user_id"],
        reviewId: json["review_id"],
        content: json["content"],
        likesCount: json["likes_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "review_id": reviewId,
        "content": content,
        "likes_count": likesCount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toMap(),
      };
}

class User {
  final int id;
  final String username;
  final String email;
  final DateTime emailVerifiedAt;
  final DateTime lastLoginAt;
  final String name;
  final dynamic bio;
  final dynamic profilePicture;
  final dynamic phoneNumber;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isVerified;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.emailVerifiedAt,
    required this.lastLoginAt,
    required this.name,
    required this.bio,
    required this.profilePicture,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
  });

  User copyWith({
    int? id,
    String? username,
    String? email,
    DateTime? emailVerifiedAt,
    DateTime? lastLoginAt,
    String? name,
    dynamic bio,
    dynamic profilePicture,
    dynamic phoneNumber,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isVerified,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        name: name ?? this.name,
        bio: bio ?? this.bio,
        profilePicture: profilePicture ?? this.profilePicture,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isVerified: isVerified ?? this.isVerified,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        lastLoginAt: DateTime.parse(json["last_login_at"]),
        name: json["name"],
        bio: json["bio"],
        profilePicture: json["profile_picture"],
        phoneNumber: json["phone_number"],
        role: json["role"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isVerified: json["is_verified"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "email_verified_at": emailVerifiedAt.toIso8601String(),
        "last_login_at": lastLoginAt.toIso8601String(),
        "name": name,
        "bio": bio,
        "profile_picture": profilePicture,
        "phone_number": phoneNumber,
        "role": role,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_verified": isVerified,
      };
}
