import 'category_model.dart';
import 'author_model.dart';
import 'chapter_model.dart';

class Novel {
  final int id;
  final String title;
  final String description;
  final String coverImage;
  final int categoryId;
  final int authorId;
  final String publicationDate;
  final int pageCount;
  final String language;
  final bool isFeatured;
  final double averageRating;
  final int viewCount;
  final List<Chapter> chapters;

  Novel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.categoryId,
    required this.authorId,
    required this.publicationDate,
    this.pageCount = 0,
    this.language = 'Indonesia',
    this.isFeatured = false,
    this.averageRating = 0.0,
    this.viewCount = 0,
    this.chapters = const [],
  });

  // Get category object
  Category get category {
    return Category.categories.firstWhere(
      (category) => category.id == categoryId,
      orElse: () => Category(id: 0, name: 'Uncategorized'),
    );
  }

  // Get author object
  Author get author {
    return Author.authors.firstWhere(
      (author) => author.id == authorId,
      orElse: () => Author(id: 0, name: 'Unknown Author'),
    );
  }

  // Dummy data
  static List<Novel> novels = [
    Novel(
      id: 1,
      title: 'Bumi',
      description: 'Novel pertama dari serial Bumi yang mengisahkan petualangan tiga remaja yang memiliki kemampuan spesial.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 2, // Fantasy
      authorId: 4, // Tere Liye
      publicationDate: '2014',
      pageCount: 440,
      isFeatured: true,
      averageRating: 4.7,
      viewCount: 15000,
      chapters: Chapter.getChaptersForNovel(1),
    ),
    Novel(
      id: 2,
      title: 'Laut Bercerita',
      description: 'Novel yang mengisahkan tentang kisah para aktivis yang hilang pada masa Orde Baru.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 3, // Mystery
      authorId: 5, // Andrea Hirata
      publicationDate: '2017',
      pageCount: 380,
      isFeatured: true,
      averageRating: 4.5,
      viewCount: 12000,
      chapters: Chapter.getChaptersForNovel(2),
    ),
    Novel(
      id: 3,
      title: 'Hujan',
      description: 'Novel tentang persahabatan dan cinta di tengah perubahan iklim yang ekstrem di masa depan.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 1, // Romance
      authorId: 4, // Tere Liye
      publicationDate: '2016',
      pageCount: 320,
      isFeatured: false,
      averageRating: 4.6,
      viewCount: 13500,
      chapters: Chapter.getChaptersForNovel(3),
    ),
    Novel(
      id: 4,
      title: 'Pulang',
      description: 'Novel tentang perjalanan hidup seorang anak muda yang merantau dan akhirnya kembali ke kampung halamannya.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 5, // Sci-Fi
      authorId: 4, // Tere Liye
      publicationDate: '2015',
      pageCount: 400,
      isFeatured: false,
      averageRating: 4.4,
      viewCount: 11000,
      chapters: Chapter.getChaptersForNovel(4),
    ),
    Novel(
      id: 5,
      title: 'Pergi',
      description: 'Sekuel dari novel Pulang yang menceritakan kelanjutan kisah tokoh utama.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 5, // Sci-Fi
      authorId: 4, // Tere Liye
      publicationDate: '2018',
      pageCount: 420,
      isFeatured: false,
      averageRating: 4.3,
      viewCount: 10000,
      chapters: Chapter.getChaptersForNovel(5),
    ),
    Novel(
      id: 6,
      title: 'Laskar Pelangi',
      description: 'Novel tentang perjuangan anak-anak di Belitung untuk mendapatkan pendidikan yang layak.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 2, // Fantasy
      authorId: 5, // Andrea Hirata
      publicationDate: '2005',
      pageCount: 529,
      isFeatured: true,
      averageRating: 4.8,
      viewCount: 20000,
      chapters: Chapter.getChaptersForNovel(6),
    ),
    Novel(
      id: 7,
      title: 'Sang Pemimpi',
      description: 'Sekuel dari Laskar Pelangi yang menceritakan perjuangan tiga sahabat untuk mengejar mimpi mereka.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 2, // Fantasy
      authorId: 5, // Andrea Hirata
      publicationDate: '2006',
      pageCount: 292,
      isFeatured: false,
      averageRating: 4.6,
      viewCount: 18000,
      chapters: Chapter.getChaptersForNovel(7),
    ),
    Novel(
      id: 8,
      title: 'Edensor',
      description: 'Bagian ketiga dari tetralogi Laskar Pelangi yang menceritakan petualangan di Eropa.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 2, // Fantasy
      authorId: 5, // Andrea Hirata
      publicationDate: '2007',
      pageCount: 310,
      isFeatured: false,
      averageRating: 4.5,
      viewCount: 15000,
      chapters: Chapter.getChaptersForNovel(8),
    ),
    Novel(
      id: 9,
      title: 'Maryamah Karpov',
      description: 'Bagian terakhir dari tetralogi Laskar Pelangi.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 2, // Fantasy
      authorId: 5, // Andrea Hirata
      publicationDate: '2008',
      pageCount: 328,
      isFeatured: false,
      averageRating: 4.4,
      viewCount: 14000,
      chapters: Chapter.getChaptersForNovel(9),
    ),
    Novel(
      id: 10,
      title: 'Negeri Para Bedebah',
      description: 'Novel tentang dunia perbankan dan keuangan di Indonesia.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 3, // Mystery
      authorId: 4, // Tere Liye
      publicationDate: '2012',
      pageCount: 440,
      isFeatured: false,
      averageRating: 4.3,
      viewCount: 12000,
      chapters: Chapter.getChaptersForNovel(10),
    ),
    Novel(
      id: 11,
      title: 'Negeri Di Ujung Tanduk',
      description: 'Sekuel dari Negeri Para Bedebah yang menceritakan petualangan Thomas di dunia politik.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 3, // Mystery
      authorId: 4, // Tere Liye
      publicationDate: '2013',
      pageCount: 360,
      isFeatured: false,
      averageRating: 4.2,
      viewCount: 11000,
      chapters: Chapter.getChaptersForNovel(11),
    ),
    Novel(
      id: 12,
      title: 'Rindu',
      description: 'Novel tentang perjalanan haji dengan kapal laut pada masa kolonial Belanda.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 1, // Romance
      authorId: 4, // Tere Liye
      publicationDate: '2014',
      pageCount: 544,
      isFeatured: true,
      averageRating: 4.7,
      viewCount: 16000,
      chapters: Chapter.getChaptersForNovel(12),
    ),
    Novel(
      id: 12,
      title: 'Rindu',
      description: 'Novel tentang perjalanan haji dengan kapal laut pada masa kolonial Belanda.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 1, // Romance
      authorId: 4, // Tere Liye
      publicationDate: '2014',
      pageCount: 544,
      isFeatured: true,
      averageRating: 4.7,
      viewCount: 16000,
      chapters: Chapter.getChaptersForNovel(12),
    ),
    Novel(
      id: 12,
      title: 'Rindu',
      description: 'Novel tentang perjalanan haji dengan kapal laut pada masa kolonial Belanda.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 1, // Romance
      authorId: 4, // Tere Liye
      publicationDate: '2014',
      pageCount: 544,
      isFeatured: true,
      averageRating: 4.7,
      viewCount: 16000,
      chapters: Chapter.getChaptersForNovel(12),
    ),
    Novel(
      id: 12,
      title: 'Rindu',
      description: 'Novel tentang perjalanan haji dengan kapal laut pada masa kolonial Belanda.',
      coverImage: 'assets/images/novel.jpeg',
      categoryId: 1, // Romance
      authorId: 4, // Tere Liye
      publicationDate: '2014',
      pageCount: 544,
      isFeatured: true,
      averageRating: 4.7,
      viewCount: 16000,
      chapters: Chapter.getChaptersForNovel(12),
    ),
  ];

  // Get featured novels
  static List<Novel> get featuredNovels {
    return novels.where((novel) => novel.isFeatured).toList();
  }

  // Get novels by category
  static List<Novel> getNovelsByCategory(int categoryId) {
    return novels.where((novel) => novel.categoryId == categoryId).toList();
  }

  // Get novels by author
  static List<Novel> getNovelsByAuthor(int authorId) {
    return novels.where((novel) => novel.authorId == authorId).toList();
  }

  // Search novels
  static List<Novel> searchNovels(String query) {
    return novels.where((novel) =>
      novel.title.toLowerCase().contains(query.toLowerCase()) ||
      novel.description.toLowerCase().contains(query.toLowerCase()) ||
      novel.author.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
