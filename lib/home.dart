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
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws/message'),
  );

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _sendMessage(String message) {
    channel.sink.add(message);
  }

  List<User> users = List.empty();

  final WebSocketChannel userChannel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws/status'),
  );

  void listenToStatusUpdates() {
    userChannel.stream.listen((message) {
      final List<dynamic> data = jsonDecode(message);
      final List<User> usersList = data
          .map((json) => User.fromJson(json))
          .toList();
      setState(() {
        users = usersList;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    listenToStatusUpdates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<FirebaseAuthProvider>(
        context,
        listen: false,
      );

      if (authProvider.uid != null) {
        userChannel.sink.add(authProvider.uid);
      }
    });
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
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.email),
                    leading: Icon(
                      Icons.circle,
                      color: user.online ? Colors.green : Colors.grey,
                      size: 12,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: channel.stream,
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
