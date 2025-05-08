class Favorite {
  final int id;
  final int userId;
  final int novelId;
  final String createdAt;

  Favorite({
    required this.id,
    required this.userId,
    required this.novelId,
    required this.createdAt,
  });

  // Dummy data
  static List<Favorite> favorites = [
    Favorite(
      id: 1,
      userId: 1,
      novelId: 1,
      createdAt: '2023-05-20',
    ),
    Favorite(
      id: 2,
      userId: 1,
      novelId: 3,
      createdAt: '2023-06-15',
    ),
    Favorite(
      id: 3,
      userId: 1,
      novelId: 6,
      createdAt: '2023-07-10',
    ),
    Favorite(
      id: 4,
      userId: 1,
      novelId: 12,
      createdAt: '2023-08-05',
    ),
    Favorite(
      id: 5,
      userId: 2,
      novelId: 2,
      createdAt: '2023-05-25',
    ),
  ];

  // Get favorites by user
  static List<Favorite> getFavoritesByUser(int userId) {
    return favorites.where((favorite) => favorite.userId == userId).toList();
  }

  // Check if a novel is favorited by a user
  static bool isNovelFavorited(int userId, int novelId) {
    return favorites.any((favorite) => 
      favorite.userId == userId && favorite.novelId == novelId
    );
  }

  // Get favorite novel IDs for a user
  static List<int> getFavoriteNovelIds(int userId) {
    return getFavoritesByUser(userId)
        .map((favorite) => favorite.novelId)
        .toList();
  }
}
