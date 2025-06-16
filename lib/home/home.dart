import 'package:flutter/material.dart';
import 'package:gameparrot/home/account_dialog.dart';
import 'package:gameparrot/home/messages.dart';
import 'package:gameparrot/home/user_list.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';
import 'message_input.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: false,
    );
    Provider.of<UsersProvider>(
      context,
      listen: false,
    ).getCurrentUser(authProvider.uid);

    initWebSockets();
  }

  Future<void> initWebSockets() async {
    final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: false,
    );
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    usersProvider.startWsChannel(authProvider.uid);
    usersProvider.listenToWS();
  }

  @override
  void dispose() {
    Provider.of<UsersProvider>(context, listen: false).closeWsChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(context);
    final sendMessage = Provider.of<UsersProvider>(
      context,
      listen: false,
    ).sendMessage;
    final selectedId = Provider.of<HomeProvider>(context).selectedId;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3460),
        title: const Text(
          'GameParrot',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(
                      value: Provider.of<UsersProvider>(context, listen: false),
                    ),
                    ChangeNotifierProvider.value(
                      value: Provider.of<FirebaseAuthProvider>(
                        context,
                        listen: false,
                      ),
                    ),
                  ],
                  child: const AccountDialog(),
                ),
              ),
              icon: const Icon(Icons.account_circle, color: Colors.white),
              tooltip: "User Info",
            ),
          ),
          IconButton(
            onPressed: authProvider.logout,
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
      ),
      body: Row(
        children: [
          if (!isMobile)
            Container(
              width: 250,
              color: const Color(0xFF16213E),
              child: UserList(),
            ),
          Expanded(
            child: Column(
              children: [
                if (isMobile && selectedId == null)
                  Expanded(child: UserList())
                else
                  Expanded(child: Messages()),
                if (selectedId != null)
                  MessageInput(
                    onSend: sendMessage,
                    backgroundColor: const Color(0xFF0F3460),
                    textColor: Colors.white,
                    hintText: 'Type your message...',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
