import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws'),
    // web/ios: ws://localhost:8080/ws, android: ws://10.0.2.2:8080/ws
  );

  Future<void> pingServer() async {
    final response = await http.get(Uri.parse('http://localhost:8080/ping'));
    print('Ping response: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    pingServer(); // call once on start

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter + Go + WS')),
        body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.hasData ? '${snapshot.data}' : 'No message'),
                  ElevatedButton(
                    onPressed: () => channel.sink.add('Hello from Flutter!'),
                    child: Text('Send to Go'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
