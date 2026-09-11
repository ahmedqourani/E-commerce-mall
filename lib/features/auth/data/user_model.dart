class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? image;
  final String? phone;
  final String? gender;
  final String? token;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.image,
    this.phone,
    this.gender,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      phone: json['phone'],
      gender: json['gender'],
      token: json['accessToken'],
    );
  }

  String get fullName => '$firstName $lastName';
}
