class Message {
  final String message;
  final String from;
  final String to;

  Message({required this.message, required this.from, required this.to});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'message': message, 'from': from, 'to': to};
}

class Friend {
  final String uid;
  final List<Message> messages;

  Friend({required this.uid, required this.messages});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      uid: json['uid'] ?? '',
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((msg) => Message.fromJson(msg))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'messages': messages.map((m) => m.toJson()).toList(),
  };
}

class User {
  final String uid;
  final String email;
  final bool online;
  final List<Friend>? friends;

  User({
    required this.uid,
    required this.email,
    required this.online,
    this.friends,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      online: json['online'] ?? false,
      friends: (json['friends'] as List<dynamic>?)
          ?.map((f) => Friend.fromJson(f))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'online': online,
    'friends': friends?.map((f) => f.toJson()).toList(),
  };
}
