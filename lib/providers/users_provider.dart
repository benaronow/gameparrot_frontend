import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gameparrot/config.dart';
import 'package:gameparrot/models/update.dart';
import 'package:gameparrot/models/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

enum MessageType { send, receive }

class UsersProvider extends ChangeNotifier {
  WebSocketChannel? _wsChannel;
  User? _currentUser;
  List<User>? _users;
  String? _selectedId;

  User? get currentUser => _currentUser;
  List<User>? get users => _users ?? [];
  String? get selectedId => _selectedId;
  List<User>? get friends =>
      _users
          ?.where(
            (u) =>
                _currentUser?.interactions?.any((i) => i.uid == u.uid) ?? false,
          )
          .toList() ??
      [];
  User? get selectedFriend => _users?.firstWhere(
    (u) => u.uid == _selectedId,
    orElse: () => User(uid: '', email: 'Unknown User', online: false),
  );

  void setSelectedId(String? id) {
    _selectedId = id;
    notifyListeners();
  }

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
            MessageType.receive,
          );
          break;
        case "friend_request":
          handleFriendRequest(
            FriendRequest(from: update.from ?? '', to: update.to ?? ''),
          );
          break;
        case "friend_accept":
          handleFriendAccept(
            FriendRequest(from: update.from ?? '', to: update.to ?? ''),
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

  void closeWsChannel() {
    _wsChannel?.sink.close();
    _wsChannel = null;
  }

  void handleStatus(List<User> status) {
    _users = status;
    notifyListeners();
  }

  void handleMessage(Message message, MessageType type) {
    if (_currentUser == null) return;

    final List<Interaction>? newInteractions = _currentUser!.interactions?.map((
      f,
    ) {
      if (f.uid == (type == MessageType.receive ? message.from : message.to)) {
        final updatedMessages = List<Message>.from(f.messages);
        updatedMessages.add(message);
        return Interaction(uid: f.uid, messages: updatedMessages);
      } else {
        return f;
      }
    }).toList();

    _currentUser = User(
      uid: _currentUser!.uid,
      email: _currentUser!.email,
      online: _currentUser!.online,
      interactions: newInteractions ?? [],
      friendRequests: _currentUser!.friendRequests,
    );

    notifyListeners();
  }

  void handleFriendRequest(FriendRequest request) {
    if (_currentUser == null) return;

    final List<FriendRequest> newRequests = _currentUser!.friendRequests ?? [];
    newRequests.add(request);

    _currentUser = User(
      uid: _currentUser!.uid,
      email: _currentUser!.email,
      online: _currentUser!.online,
      interactions: _currentUser!.interactions,
      friendRequests: newRequests,
    );

    notifyListeners();
  }

  void handleFriendAccept(FriendRequest request) {
    if (_currentUser == null) return;

    final List<FriendRequest> newRequests = _currentUser!.friendRequests ?? [];
    newRequests.removeWhere(
      (r) => r.from == request.from && r.to == request.to,
    );

    final Interaction newInteraction = Interaction(
      uid: request.from == currentUser!.uid ? request.to : request.from,
      messages: [],
    );
    final List<Interaction> newInteractions = List.from(
      _currentUser!.interactions ?? [],
    );
    newInteractions.add(newInteraction);

    _currentUser = User(
      uid: _currentUser!.uid,
      email: _currentUser!.email,
      online: _currentUser!.online,
      interactions: newInteractions,
      friendRequests: newRequests,
    );

    notifyListeners();
  }

  void sendMessage(String messageText, String from, String? to) {
    if (_currentUser == null || to == null) return;

    final message = Message(message: messageText, from: from, to: to);
    final msgJson = {
      "type": "message",
      "message": messageText,
      "from": from,
      "to": to,
    };

    _wsChannel?.sink.add(jsonEncode(msgJson));

    handleMessage(message, MessageType.send);

    notifyListeners();
  }

  void sendFriendRequest(String from, String to) {
    if (_currentUser == null) return;

    final request = FriendRequest(from: from, to: to);
    final requestJson = {"type": "friend_request", "from": from, "to": to};

    _wsChannel?.sink.add(jsonEncode(requestJson));

    handleFriendRequest(request);
  }

  void sendFriendAccept(String from, String to) {
    if (_currentUser == null) return;

    final request = FriendRequest(from: from, to: to);
    final requestJson = {"type": "friend_accept", "from": from, "to": to};

    _wsChannel?.sink.add(jsonEncode(requestJson));

    handleFriendAccept(request);
  }
}
