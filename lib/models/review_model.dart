class Review {
  final int id;
  final int userId;
  final int novelId;
  final int rating;
  final String comment;
  final int likesCount;
  final bool isSpoiler;
  final String createdAt;
  final String username;
  final String userProfilePicture;

  Review({
    required this.id,
    required this.userId,
    required this.novelId,
    required this.rating,
    required this.comment,
    this.likesCount = 0,
    this.isSpoiler = false,
    required this.createdAt,
    required this.username,
    required this.userProfilePicture,
  });

  // Dummy data
  static List<Review> reviews = [
    Review(
      id: 1,
      userId: 1,
      novelId: 1,
      rating: 5,
      comment: 'Novel yang sangat menarik! Saya sangat menikmati alur ceritanya dan karakter-karakternya yang berkembang dengan baik.',
      likesCount: 24,
      isSpoiler: false,
      createdAt: '2023-05-15',
      username: 'johndoe',
      userProfilePicture: 'assets/images/profile.jpg',
    ),
    Review(
      id: 2,
      userId: 2,
      novelId: 1,
      rating: 4,
      comment: 'Ceritanya bagus, tapi ada beberapa bagian yang menurut saya terlalu bertele-tele. Secara keseluruhan tetap memuaskan.',
      likesCount: 12,
      isSpoiler: false,
      createdAt: '2023-06-20',
      username: 'janedoe',
      userProfilePicture: 'assets/images/user2.jpg',
    ),
    Review(
      id: 3,
      userId: 3,
      novelId: 2,
      rating: 5,
      comment: 'Salah satu novel terbaik yang pernah saya baca! Penulisnya sangat pandai menggambarkan suasana dan emosi karakter.',
      likesCount: 35,
      isSpoiler: false,
      createdAt: '2023-04-10',
      username: 'alexsmith',
      userProfilePicture: 'assets/images/user3.jpg',
    ),
    Review(
      id: 4,
      userId: 4,
      novelId: 3,
      rating: 3,
      comment: 'Novel ini cukup bagus, tapi tidak sesuai ekspektasi saya. Alurnya agak lambat di awal.',
      likesCount: 8,
      isSpoiler: false,
      createdAt: '2023-07-05',
      username: 'sarahlee',
      userProfilePicture: 'assets/images/user4.jpg',
    ),
    Review(
      id: 5,
      userId: 5,
      novelId: 4,
      rating: 4,
      comment: 'Saya suka cara penulis mengembangkan karakter utama. Sangat relatable dan membuat saya terus membaca.',
      likesCount: 19,
      isSpoiler: false,
      createdAt: '2023-03-25',
      username: 'mikebrown',
      userProfilePicture: 'assets/images/user5.jpg',
    ),
  ];

  // Get reviews by novel
  static List<Review> getReviewsByNovel(int novelId) {
    return reviews.where((review) => review.novelId == novelId).toList();
  }

  // Get reviews by user
  static List<Review> getReviewsByUser(int userId) {
    return reviews.where((review) => review.userId == userId).toList();
  }

  // Get average rating for a novel
  static double getAverageRating(int novelId) {
    var novelReviews = getReviewsByNovel(novelId);
    if (novelReviews.isEmpty) return 0;
    
    var totalRating = novelReviews.fold(0, (sum, review) => sum + review.rating);
    return totalRating / novelReviews.length;
  }
}
