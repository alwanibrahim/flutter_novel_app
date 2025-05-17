// To parse this JSON data, do
//
//     final Data = DatafromJson(jsonString);

import 'dart:convert';

Data DatafromJson(String str) => Data.fromJson(json.decode(str));

String DataToMap(Data data) => json.encode(data.toMap());

class Data {
    final bool success;
    final List<SavedNovel> data;

    Data({
        required this.success,
        required this.data,
    });

    Data copyWith({
        bool? success,
        List<SavedNovel>? data,
    }) =>
        Data(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],
        data: List<SavedNovel>.from(json["data"].map((x) => SavedNovel.fromJson(x))),
    );

    Map<String, dynamic> toMap() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class SavedNovel {
    final int id;
    final String title;
    final String description;
    final String coverImage;
    final int categoryId;
    final int authorId;
    final DateTime publicationDate;
    final dynamic pageCount;
    final String language;
    final bool isFeatured;
    final int averageRating;
    final int viewCount;
    final DateTime createdAt;
    final DateTime updatedAt;

    SavedNovel({
        required this.id,
        required this.title,
        required this.description,
        required this.coverImage,
        required this.categoryId,
        required this.authorId,
        required this.publicationDate,
        required this.pageCount,
        required this.language,
        required this.isFeatured,
        required this.averageRating,
        required this.viewCount,
        required this.createdAt,
        required this.updatedAt,
    });

    SavedNovel copyWith({
        int? id,
        String? title,
        String? description,
        String? coverImage,
        int? categoryId,
        int? authorId,
        DateTime? publicationDate,
        dynamic pageCount,
        String? language,
        bool? isFeatured,
        int? averageRating,
        int? viewCount,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) =>
        SavedNovel(
            id: id ?? this.id,
            title: title ?? this.title,
            description: description ?? this.description,
            coverImage: coverImage ?? this.coverImage,
            categoryId: categoryId ?? this.categoryId,
            authorId: authorId ?? this.authorId,
            publicationDate: publicationDate ?? this.publicationDate,
            pageCount: pageCount ?? this.pageCount,
            language: language ?? this.language,
            isFeatured: isFeatured ?? this.isFeatured,
            averageRating: averageRating ?? this.averageRating,
            viewCount: viewCount ?? this.viewCount,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory SavedNovel.fromJson(Map<String, dynamic> json) => SavedNovel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        coverImage: json["cover_image"],
        categoryId: json["category_id"],
        authorId: json["author_id"],
        publicationDate: DateTime.parse(json["publication_date"]),
        pageCount: json["page_count"],
        language: json["language"],
        isFeatured: json["is_featured"],
        averageRating: json["average_rating"],
        viewCount: json["view_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "cover_image": coverImage,
        "category_id": categoryId,
        "author_id": authorId,
        "publication_date": publicationDate.toIso8601String(),
        "page_count": pageCount,
        "language": language,
        "is_featured": isFeatured,
        "average_rating": averageRating,
        "view_count": viewCount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
