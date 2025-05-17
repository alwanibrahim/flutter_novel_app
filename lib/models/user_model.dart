class User {
  final int id;
  final String username;
  final String email;
  final String name;
  final String bio;
  final String profilePicture;
  final String createdAt;
  final String role;
  final String phoneNumber;
  final bool isActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    this.bio = '',
    required this.profilePicture,
    required this.createdAt,
    this.role = 'user',
    this.phoneNumber = '',
    this.isActive = true,
  });

  // Dummy data
  static User currentUser = User(
    id: 1,
    username: 'johndoe',
    email: 'john.doe@example.com',
    name: 'John Doe',
    bio: 'Pecinta novel dan buku-buku fiksi. Suka membaca di waktu luang.',
    profilePicture: 'assets/images/novel.jpeg',
    createdAt: 'Januari 2023',
    phoneNumber: '+62812345678',
  );
}
