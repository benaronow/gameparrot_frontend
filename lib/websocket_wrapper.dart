import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'message_input.dart'; // <--- import the new widget

class WebSocketWrapper extends StatefulWidget {
  final WebSocketChannel channel;

  const WebSocketWrapper({super.key, required this.channel});

  @override
  State<WebSocketWrapper> createState() => _WebSocketWrapperState();
}

class _WebSocketWrapperState extends State<WebSocketWrapper> {
  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  void _sendMessage(String message) {
    widget.channel.sink.add(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter + Go + WebSocket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: widget.channel.stream,
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
            MessageInput(onSend: _sendMessage), // <--- new widget here
          ],
        ),
      ),
    );
  }
}
