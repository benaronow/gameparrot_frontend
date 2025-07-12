import 'package:flutter/material.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';

/// Service responsible for managing WebSocket connections
class WebSocketService {
  static UsersProvider? _usersProvider;
  static FirebaseAuthProvider? _authProvider;

  static Future<void> initialize(BuildContext context) async {
    _usersProvider = Provider.of<UsersProvider>(context, listen: false);
    _authProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);

    final uid = _authProvider?.uid;
    if (uid != null) {
      await _usersProvider?.getCurrentUser(uid);
      _initWebSocketsSync(_usersProvider!, uid);
    }
  }

  static void _initWebSocketsSync(UsersProvider p, String uid) {
    p.startWsChannel(uid);
    p.listenToWS();
  }

  static void dispose() {
    _usersProvider?.closeWsChannel();
    _usersProvider = null;
    _authProvider = null;
  }
}
