// To parse this JSON data, do
//
//     final data = datafromJson(jsonString);

import 'dart:convert';

Data datafromJson(String str) => Data.fromJson(json.decode(str));

String dataToMap(Data data) => json.encode(data.toMap());

class Data {
  final bool status;
  final DataClass data;

  Data({
    required this.status,
    required this.data,
  });

  Data copyWith({
    bool? status,
    DataClass? data,
  }) =>
      Data(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        data: DataClass.fromJson(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data.toMap(),
      };
}

class DataClass {
  final int currentPage;
  final List<NovelModel> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String path;
  final int perPage;
  final dynamic prevPageUrl;
  final int to;
  final int total;

  DataClass({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  DataClass copyWith({
    int? currentPage,
    List<NovelModel>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<Link>? links,
    dynamic nextPageUrl,
    String? path,
    int? perPage,
    dynamic prevPageUrl,
    int? to,
    int? total,
  }) =>
      DataClass(
        currentPage: currentPage ?? this.currentPage,
        data: data ?? this.data,
        firstPageUrl: firstPageUrl ?? this.firstPageUrl,
        from: from ?? this.from,
        lastPage: lastPage ?? this.lastPage,
        lastPageUrl: lastPageUrl ?? this.lastPageUrl,
        links: links ?? this.links,
        nextPageUrl: nextPageUrl ?? this.nextPageUrl,
        path: path ?? this.path,
        perPage: perPage ?? this.perPage,
        prevPageUrl: prevPageUrl ?? this.prevPageUrl,
        to: to ?? this.to,
        total: total ?? this.total,
      );

  factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
        currentPage: json["current_page"],
        data: List<NovelModel>.from(json["data"].map((x) => NovelModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toMap())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class NovelModel {
  final int id;
  final String title;
  final String description;
  final String coverImage;
  final int categoryId;
  final int authorId;
  final DateTime publicationDate;
  final dynamic pageCount;
  final Language language;
  final bool isFeatured;
  final int averageRating;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Author author;
  final Category category;
  final List<dynamic> favorites;
  final List<Review>? reviews;
  final List<Chapter>? chapters;

  NovelModel({
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
    required this.author,
    required this.category,
    required this.favorites,
     this.reviews,
     this.chapters,
  });

  NovelModel copyWith({
    int? id,
    String? title,
    String? description,
    String? coverImage,
    int? categoryId,
    int? authorId,
    DateTime? publicationDate,
    dynamic pageCount,
    Language? language,
    bool? isFeatured,
    int? averageRating,
    int? viewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Author? author,
    Category? category,
    List<dynamic>? favorites,
    List<Review>? reviews,
    List<Chapter>? chapters,
  }) =>
      NovelModel(
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
        author: author ?? this.author,
        category: category ?? this.category,
        favorites: favorites ?? this.favorites,
        reviews: reviews ?? this.reviews,
        chapters: chapters ?? this.chapters,
      );

  factory NovelModel.fromJson(Map<String, dynamic> json) => NovelModel(
        id: json["id"]??'null',
        title: json["title"]??'null',
        description: json["description"]??'null',
        coverImage: json["cover_image"],
        categoryId: json["category_id"],
        authorId: json["author_id"],
        publicationDate: DateTime.parse(json["publication_date"]),
        pageCount: json["page_count"],
        language: languageValues.map[json["language"]]!,
        isFeatured: json["is_featured"],
        averageRating: json["average_rating"],
        viewCount: json["view_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        author: Author.fromJson(json["author"]),
        category: Category.fromJson(json["category"]),
        favorites: List<dynamic>.from(json["favorites"].map((x) => x)),
        reviews: json['reviews'] is List
            ? (json['reviews'] as List).map((r) => Review.fromJson(r)).toList()
            : [],


        chapters: json['chapters'] is List
            ? (json['chapters'] as List).map((r) => Chapter.fromJson(r)).toList()
            : [],

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
        "language": languageValues.reverse[language],
        "is_featured": isFeatured,
        "average_rating": averageRating,
        "view_count": viewCount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "author": author.toMap(),
        "category": category.toMap(),
        "favorites": List<dynamic>.from(favorites.map((x) => x)),
        // "reviews": List<dynamic>.from(reviews.map((x) => x.toMap())),
        // "chapters": List<dynamic>.from(chapters.map((x) => x.toMap())),
      };
}

class Author {
  final int id;
  final String name;
  final String bio;
  final String profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  Author({
    required this.id,
    required this.name,
    required this.bio,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  Author copyWith({
    int? id,
    String? name,
    String? bio,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Author(
        id: id ?? this.id,
        name: name ?? this.name,
        bio: bio ?? this.bio,
        profilePicture: profilePicture ?? this.profilePicture,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        bio: json["bio"],
        profilePicture: json["profile_picture"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "bio": bio,
        "profile_picture": profilePicture,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Category {
  final int id;
  final String name;
  final String description;
  final dynamic icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  Category copyWith({
    int? id,
    String? name,
    String? description,
    dynamic icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        icon: json["icon"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "icon": icon,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Chapter {
  final int id;
  final int novelId;
  final String title;
  final String content;
  final int chapterNumber;
  final int wordCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chapter({
    required this.id,
    required this.novelId,
    required this.title,
    required this.content,
    required this.chapterNumber,
    required this.wordCount,
    required this.createdAt,
    required this.updatedAt,
  });

  Chapter copyWith({
    int? id,
    int? novelId,
    String? title,
    String? content,
    int? chapterNumber,
    int? wordCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Chapter(
        id: id ?? this.id,
        novelId: novelId ?? this.novelId,
        title: title ?? this.title,
        content: content ?? this.content,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        wordCount: wordCount ?? this.wordCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json["id"],
        novelId: json["novel_id"],
        title: json["title"],
        content: json["content"],
        chapterNumber: json["chapter_number"],
        wordCount: json["word_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "novel_id": novelId,
        "title": title,
        "content": content,
        "chapter_number": chapterNumber,
        "word_count": wordCount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

enum Language { EN }

final languageValues = EnumValues({"en": Language.EN});

class Review {
  final int id;
  final int userId;
  final int novelId;
  final int rating;
  final String comment;
  final int likesCount;
  final bool isSpoiler;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  Review({
    required this.id,
    required this.userId,
    required this.novelId,
    required this.rating,
    required this.comment,
    required this.likesCount,
    required this.isSpoiler,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  Review copyWith({
    int? id,
    int? userId,
    int? novelId,
    int? rating,
    String? comment,
    int? likesCount,
    bool? isSpoiler,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) =>
      Review(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        novelId: novelId ?? this.novelId,
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        likesCount: likesCount ?? this.likesCount,
        isSpoiler: isSpoiler ?? this.isSpoiler,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        userId: json["user_id"],
        novelId: json["novel_id"],
        rating: json["rating"] ?? 0 .toString(),
        comment: json["comment"],
        likesCount: json["likes_count"],
        isSpoiler: json["is_spoiler"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "novel_id": novelId,
        "rating": rating,
        "comment": comment,
        "likes_count": likesCount,
        "is_spoiler": isSpoiler,
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
  final dynamic lastLoginAt;
  final String name;
  final dynamic bio;
  final String? profilePicture;
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
    dynamic lastLoginAt,
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
        lastLoginAt: json["last_login_at"],
        name: json["name"],
        bio: json["bio"]??'-',
        profilePicture: json["profile_picture"],
        phoneNumber: json["phone_number"]??'+62',
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
        "last_login_at": lastLoginAt,
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

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  Link copyWith({
    String? url,
    String? label,
    bool? active,
  }) =>
      Link(
        url: url ?? this.url,
        label: label ?? this.label,
        active: active ?? this.active,
      );

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}


class FavoriteStatus {
  final bool isFavorite;

  FavoriteStatus({required this.isFavorite});

  factory FavoriteStatus.fromJson(Map<String, dynamic> json) {
    return FavoriteStatus(
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}
