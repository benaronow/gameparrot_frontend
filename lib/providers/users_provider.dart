import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gameparrot/config.dart';
import 'package:gameparrot/models/update.dart';
import 'package:gameparrot/models/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class UsersProvider extends ChangeNotifier {
  WebSocketChannel? _wsChannel;
  User? _currentUser;
  List<User>? _users;

  User? get currentUser => _currentUser;
  List<User>? get users => _users;

  Future<void> getCurrentUser(String? uid) async {
    final uri = Uri.parse('${Config.httpUrl}/currentUser?uid=${uid ?? ''}');

    final userResponse = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    _currentUser = User.fromJson(jsonDecode(userResponse.body));
  }

  Future<void> startWsChannel(String? uid) async {
    final WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse('${Config.wsUrl}?uid=$uid'),
    );
    _wsChannel = channel;
    await channel.ready;

    if (uid != null) _wsChannel?.sink.add(uid);
  }

  void listenToWS() {
    _wsChannel?.stream.listen((message) {
      final Update update = Update.fromJson(jsonDecode(message));

      switch (update.type) {
        case "message":
          handleMessage(
            Message(
              message: update.message ?? '',
              from: update.from ?? '',
              to: update.to ?? '',
            ),
          );
          break;
        case "status":
          handleStatus(update.status ?? []);
          break;
        default:
          break;
      }
    });
  }

  void handleMessage(Message message) {
    final List<Friend>? newFriends = _currentUser?.friends?.map((f) {
      if (f.uid == message.from) {
        final updatedMessages = List<Message>.from(f.messages);
        updatedMessages.add(message);
        return Friend(uid: f.uid, messages: updatedMessages);
      } else {
        return f;
      }
    }).toList();
    _currentUser = User(
      uid: _currentUser?.uid ?? "",
      email: _currentUser?.email ?? "",
      online: _currentUser?.online ?? false,
      friends: newFriends ?? [],
    );
    notifyListeners();
  }

  void handleStatus(List<User> status) {
    _users = status;
    notifyListeners();
  }

  void sendMessage(String message, String from, String? to) {
    if (to == null) return;
    final msgJson = {
      "type": "message",
      "message": message,
      "from": from,
      "to": to,
    };
    _wsChannel?.sink.add(jsonEncode(msgJson));
    final List<Friend> newFriends =
        _currentUser?.friends?.map((f) {
          if (f.uid == to) {
            final updatedMessages = [
              ...f.messages,
              Message(message: message, from: from, to: to),
            ];
            return Friend(uid: f.uid, messages: updatedMessages);
          } else {
            return f;
          }
        }).toList() ??
        [];
    _currentUser = User(
      uid: _currentUser?.uid ?? "",
      email: _currentUser?.email ?? "",
      online: _currentUser?.online ?? false,
      friends: newFriends,
    );
    notifyListeners();
  }

  void closeWsChannel() {
    _wsChannel?.sink.close();
  }
}
