import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws'),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter + Go Game')),
        body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            return Column(
              children: [
                TextField(
                  onSubmitted: (msg) => channel.sink.add(msg),
                  decoration: InputDecoration(labelText: "Send message"),
                ),
                Text('Received: ${snapshot.data ?? ''}')
              ],
            );
          },
        ),
      ),
    );
  }
}
