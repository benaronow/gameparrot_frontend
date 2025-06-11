import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gameparrot/models/user.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'message_input.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WebSocketChannel? statusChannel;
  WebSocketChannel? messageChannel;
  String? selectedUserId;

  Future<void> initWebSockets() async {
    final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: false,
    );

    final status = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8080/ws/status'),
    );
    await status.ready;

    final message = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8080/ws/message'),
    );

    setState(() {
      statusChannel = status;
      messageChannel = message;
    });

    if (authProvider.uid != null) {
      status.sink.add(authProvider.uid);
      message.sink.add(authProvider.uid);
    }

    listenToStatusUpdates();
  }

  List<User> users = List.empty();

  void listenToStatusUpdates() {
    statusChannel?.stream.listen((message) {
      final List<dynamic> data = jsonDecode(message);
      final List<User> usersList = data
          .map((json) => User.fromJson(json))
          .toList();
      setState(() {
        users = usersList;
      });
    });
  }

  void _sendMessage(String message, String uid) {
    if (selectedUserId == null) return;
    final msgJson = {"message": message, "from": uid, "to": selectedUserId};
    messageChannel?.sink.add(jsonEncode(msgJson));
  }

  @override
  void initState() {
    super.initState();
    initWebSockets();
  }

  @override
  void dispose() {
    statusChannel?.sink.close();
    messageChannel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('GameParrot')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedUserId,
              onChanged: (value) {
                setState(() {
                  selectedUserId = value;
                });
              },
              hint: const Text('Select a user to message'),
              items: users.map((user) {
                return DropdownMenuItem<String>(
                  value: user.uid,
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: user.online ? Colors.green : Colors.grey,
                        size: 10,
                      ),
                      const SizedBox(width: 8),
                      Text(user.email),
                    ],
                  ),
                );
              }).toList(),
            ),
            Expanded(
              child: StreamBuilder(
                stream: messageChannel?.stream,
                builder: (context, snapshot) {
                  return Center(
                    child: Text(
                      snapshot.hasData ? '${snapshot.data}' : 'No message yet',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
            MessageInput(onSend: _sendMessage),
            ElevatedButton(
              onPressed: authProvider.logout,
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
