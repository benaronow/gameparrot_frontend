class User {
  final String uid;
  final String email;
  final bool online;

  User({required this.uid, required this.email, required this.online});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      online: json['online'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'online': online};
  }
}
