// To parse this JSON data, do
//
//     final data = datafromJson(jsonString);

import 'dart:convert';

Data datafromJson(String str) => Data.fromJson(json.decode(str));

String dataToMap(Data data) => json.encode(data.toMap());

class Data {
    final bool status;
    final String message;
    final List<ReviewModel> data;

    Data({
        required this.status,
        required this.message,
        required this.data,
    });

    Data copyWith({
        bool? status,
        String? message,
        List<ReviewModel>? data,
    }) =>
        Data(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        data: List<ReviewModel>.from(json["data"].map((x) => ReviewModel.fromJson(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Novel {
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
    final Author author;
    final Category category;
    final List<Favorite> favorites;
    final List<ReviewModel> reviews;
    final List<Chapter> chapters;

    Novel({
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
        required this.reviews,
        required this.chapters,
    });

    Novel copyWith({
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
        Author? author,
        Category? category,
        List<Favorite>? favorites,
        List<ReviewModel>? reviews,
        List<Chapter>? chapters,
    }) =>
        Novel(
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

    factory Novel.fromJson(Map<String, dynamic> json) => Novel(
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
        author: Author.fromJson(json["author"]),
        category: Category.fromJson(json["category"]),
        favorites: List<Favorite>.from(json["favorites"].map((x) => Favorite.fromJson(x))),
        reviews: List<ReviewModel>.from(json["reviews"].map((x) => ReviewModel.fromJson(x))),
        chapters: List<Chapter>.from(json["chapters"].map((x) => Chapter.fromJson(x))),
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
        "author": author.toMap(),
        "category": category.toMap(),
        "favorites": List<dynamic>.from(favorites.map((x) => x.toMap())),
        "reviews": List<dynamic>.from(reviews.map((x) => x.toMap())),
        "chapters": List<dynamic>.from(chapters.map((x) => x.toMap())),
    };
}

class ReviewModel {
    final int id;
    final int userId;
    final int novelId;
    final int rating;
    final String comment;
    final int likesCount;
    final bool isSpoiler;
    final DateTime createdAt;
    final DateTime updatedAt;
    final Novel? novel;
    final User user;

    ReviewModel({
        required this.id,
        required this.userId,
        required this.novelId,
        required this.rating,
        required this.comment,
        required this.likesCount,
        required this.isSpoiler,
        required this.createdAt,
        required this.updatedAt,
        this.novel,
        required this.user,
    });

    ReviewModel copyWith({
        int? id,
        int? userId,
        int? novelId,
        int? rating,
        String? comment,
        int? likesCount,
        bool? isSpoiler,
        DateTime? createdAt,
        DateTime? updatedAt,
        Novel? novel,
        User? user,
    }) =>
        ReviewModel(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            novelId: novelId ?? this.novelId,
            rating: rating ?? this.rating,
            comment: comment ?? this.comment,
            likesCount: likesCount ?? this.likesCount,
            isSpoiler: isSpoiler ?? this.isSpoiler,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            novel: novel ?? this.novel,
            user: user ?? this.user,
        );

    factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        userId: json["user_id"],
        novelId: json["novel_id"],
        rating: json["rating"],
        comment: json["comment"],
        likesCount: json["likes_count"],
        isSpoiler: json["is_spoiler"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        novel: json["novel"] == null ? null : Novel.fromJson(json["novel"]),
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
        "novel": novel?.toMap(),
        "user": user.toMap(),
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

class Favorite {
    final int id;
    final int userId;
    final int novelId;
    final DateTime createdAt;
    final User user;

    Favorite({
        required this.id,
        required this.userId,
        required this.novelId,
        required this.createdAt,
        required this.user,
    });

    Favorite copyWith({
        int? id,
        int? userId,
        int? novelId,
        DateTime? createdAt,
        User? user,
    }) =>
        Favorite(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            novelId: novelId ?? this.novelId,
            createdAt: createdAt ?? this.createdAt,
            user: user ?? this.user,
        );

    factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json["id"],
        userId: json["user_id"],
        novelId: json["novel_id"],
        createdAt: DateTime.parse(json["created_at"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "novel_id": novelId,
        "created_at": createdAt.toIso8601String(),
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
    final String profilePicture;
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
        String? profilePicture,
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
