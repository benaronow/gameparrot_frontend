import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameparrot/auth.dart';
import 'package:gameparrot/websocket_wrapper.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDLgYXSj6PN1ArQZM6zCWiNRtGN63knEoQ",
        authDomain: "gameparrot-42906.firebaseapp.com",
        projectId: "gameparrot-42906",
        storageBucket: "gameparrot-42906.firebasestorage.app",
        messagingSenderId: "374287975014",
        appId: "1:374287975014:web:782c0254421addeec1e3a7",
        measurementId: "G-N6V4Q493L6",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class UserInformation {
  String? uid;
  String? username;
}

class _MyAppState extends State<MyApp> {
  String? _idToken;
  late WebSocketChannel channel;

  void _handleLoginSuccess(String idToken) {
    setState(() {
      _idToken = idToken;
      channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/ws'));
    });
    print("User logged in with token: $idToken");

    // Now you can connect your WebSocket or HTTP requests with this token
  }

  Future<void> pingServer() async {
    final response = await http.get(Uri.parse('http://localhost:8080/ping'));
    print('Ping response: ${response.body}');
  }

  @override
  void initState() {
    super.initState();
    pingServer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _idToken == null
          ? AuthScreen(onLoginSuccess: _handleLoginSuccess)
          : WebSocketWrapper(channel: channel),
    );
  }
}
