// To parse this JSON data, do
//
//     final data = datafromJson(jsonString);

import 'dart:convert';

Data datafromJson(String str) => Data.fromJson(json.decode(str));

String datatoJson(Data data) => json.encode(data.toJson());

class Data {
  final bool status;
  final List<TagModel> data;

  Data({
    required this.status,
    required this.data,
  });

  Data copyWith({
    bool? status,
    List<TagModel>? data,
  }) =>
      Data(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        data: List<TagModel>.from(json["data"].map((x) => TagModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TagModel {
  final int id;
  final String name;
  final dynamic description;
  final DateTime createdAt;

  TagModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  TagModel copyWith({
    int? id,
    String? name,
    dynamic description,
    DateTime? createdAt,
  }) =>
      TagModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
      );

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_at": createdAt.toIso8601String(),
      };
}
