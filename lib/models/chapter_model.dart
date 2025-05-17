class Chapter {
  final int id;
  final int novelId;
  final String title;
  final String content;
  final int chapterNumber;
  final int wordCount;

  Chapter({
    required this.id,
    required this.novelId,
    required this.title,
    required this.content,
    required this.chapterNumber,
    this.wordCount = 0,
  });

  // Dummy data generator for chapters
  static List<Chapter> getChaptersForNovel(int novelId) {
    // Generate 5 chapters for each novel
    return List.generate(5, (index) {
      return Chapter(
        id: novelId * 100 + index + 1,
        novelId: novelId,
        title: 'Bab ${index + 1}: ${_getChapterTitle(index)}',
        content: _generateDummyContent(),
        chapterNumber: index + 1,
        wordCount: 1500 + (index * 200), // Random word count
      );
    });
  }

  // Helper method to generate chapter titles
  static String _getChapterTitle(int index) {
    List<String> titles = [
      'Awal Mula',
      'Pertemuan',
      'Konflik',
      'Perjalanan',
      'Penyelesaian',
    ];
    return titles[index % titles.length];
  }

  // Helper method to generate dummy content
  static String _generateDummyContent() {
    return '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.

Paragraf kedua dari novel ini. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.

Paragraf ketiga dari novel ini. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.

Paragraf keempat dari novel ini. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.

Paragraf kelima dari novel ini. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.

Paragraf keenam dari novel ini. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.

Paragraf ketujuh dari novel ini. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.

Paragraf kedelapan dari novel ini. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.
''';
  }
}
