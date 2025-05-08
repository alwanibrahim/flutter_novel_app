class ReadingHistory {
  final int id;
  final int userId;
  final int novelId;
  final int chapterId;
  final int lastPageRead;
  final double progressPercentage;
  final String lastReadAt;

  ReadingHistory({
    required this.id,
    required this.userId,
    required this.novelId,
    required this.chapterId,
    this.lastPageRead = 1,
    required this.progressPercentage,
    required this.lastReadAt,
  });

  // Dummy data
  static List<ReadingHistory> readingHistories = [
    ReadingHistory(
      id: 1,
      userId: 1,
      novelId: 1,
      chapterId: 101,
      lastPageRead: 15,
      progressPercentage: 0.35,
      lastReadAt: '2023-08-10 14:30:00',
    ),
    ReadingHistory(
      id: 2,
      userId: 1,
      novelId: 3,
      chapterId: 302,
      lastPageRead: 8,
      progressPercentage: 0.20,
      lastReadAt: '2023-08-12 20:15:00',
    ),
    ReadingHistory(
      id: 3,
      userId: 1,
      novelId: 6,
      chapterId: 601,
      lastPageRead: 5,
      progressPercentage: 0.10,
      lastReadAt: '2023-08-15 21:45:00',
    ),
    ReadingHistory(
      id: 4,
      userId: 2,
      novelId: 2,
      chapterId: 203,
      lastPageRead: 20,
      progressPercentage: 0.60,
      lastReadAt: '2023-08-11 19:20:00',
    ),
    ReadingHistory(
      id: 5,
      userId: 3,
      novelId: 4,
      chapterId: 402,
      lastPageRead: 12,
      progressPercentage: 0.40,
      lastReadAt: '2023-08-13 22:10:00',
    ),
  ];

  // Get reading history by user
  static List<ReadingHistory> getReadingHistoryByUser(int userId) {
    return readingHistories.where((history) => history.userId == userId).toList();
  }

  // Get last read chapter for a novel by user
  static ReadingHistory? getLastReadChapter(int userId, int novelId) {
    try {
      return readingHistories.firstWhere(
        (history) => history.userId == userId && history.novelId == novelId,
      );
    } catch (e) {
      return null;
    }
  }
}
