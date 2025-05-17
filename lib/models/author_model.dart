class Author {
  final int id;
  final String name;
  final String bio;
  final String profilePicture;

  Author({
    required this.id,
    required this.name,
    this.bio = '',
    this.profilePicture = '',
  });

  // Dummy data
  static List<Author> authors = [
    Author(
      id: 1,
      name: 'J.K. Rowling',
      bio: 'Penulis terkenal seri Harry Potter',
      profilePicture: 'assets/images/author1.jpg',
    ),
    Author(
      id: 2,
      name: 'George R.R. Martin',
      bio: 'Penulis seri A Song of Ice and Fire',
      profilePicture: 'assets/images/author2.jpg',
    ),
    Author(
      id: 3,
      name: 'Stephen King',
      bio: 'Raja horor modern dengan lebih dari 60 novel',
      profilePicture: 'assets/images/author3.jpg',
    ),
    Author(
      id: 4,
      name: 'Tere Liye',
      bio: 'Penulis novel Indonesia terkenal',
      profilePicture: 'assets/images/author4.jpg',
    ),
    Author(
      id: 5,
      name: 'Andrea Hirata',
      bio: 'Penulis Laskar Pelangi',
      profilePicture: 'assets/images/author5.jpg',
    ),
  ];
}
