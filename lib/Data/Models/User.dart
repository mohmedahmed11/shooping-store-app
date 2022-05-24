class User {
  final int id;
  final String name;
  final String phone;
  final String password;
  User(
      {required this.id,
      required this.name,
      required this.phone,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        password: json['password']);
  }
}
