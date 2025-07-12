import 'package:flutter/material.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';

/// Service responsible for managing WebSocket connections
class WebSocketService {
  static Future<void> initialize(BuildContext context) async {
    final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: false,
    );
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    final uid = authProvider.uid;
    if (uid != null) {
      await usersProvider.getCurrentUser(uid);
      // Use a separate method to avoid async gap
      _initWebSocketsSync(usersProvider, uid);
    }
  }

  static void _initWebSocketsSync(UsersProvider usersProvider, String uid) {
    usersProvider.startWsChannel(uid);
    usersProvider.listenToWS();
  }

  static void dispose(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    usersProvider.closeWsChannel();
  }
}
