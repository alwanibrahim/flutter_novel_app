class LoginResponse {
  final String token;
  final String message;
  final bool isVerified;
  final int userId;

  LoginResponse({
    required this.token,
    required this.message,
    required this.isVerified,
     required this.userId,
  });

 factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final user = data['user'] ?? {};

    return LoginResponse(
      token: data['token'] ?? '',
      message: json['message'] ?? '',
      isVerified: data['is_verified'] == true || data['is_verified'] == 1,
      userId: user['id'] ?? 0, // fallback ke 0 kalau null
    );
  }

}

class User {
  final int id;
  final String name;
  final String email;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'], // Token diambil dari luar objek user
    );
  }
}
