import 'package:flutter/material.dart';
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
    Uri.parse('ws://localhost:8080/ws'),
  );

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _sendMessage(String message) {
    channel.sink.add(message);
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
