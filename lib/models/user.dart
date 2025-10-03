class User {
  final String email;
  final String password;

  User({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
