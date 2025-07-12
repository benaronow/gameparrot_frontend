import 'package:flutter/material.dart';
import 'package:gameparrot/home/account_dialog.dart';
import 'package:gameparrot/home/messages/messages.dart';
import 'package:gameparrot/home/user_list.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:gameparrot/theme.dart';
import 'package:provider/provider.dart';
import 'message_input.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UsersProvider _usersProvider;

  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: false,
    );

    _usersProvider = Provider.of<UsersProvider>(context, listen: false);

    _usersProvider.getCurrentUser(authProvider.uid);

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
    _usersProvider.closeWsChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final authProvider = Provider.of<FirebaseAuthProvider>(context);
    final sendMessage = Provider.of<UsersProvider>(
      context,
      listen: false,
    ).sendMessage;
    final friendIds = usersProvider.currentUser?.friends?.map((f) => f.uid);
    final friends = usersProvider.users
        ?.where((u) => friendIds?.contains(u.uid) ?? false)
        .toList();
    final selectedId = Provider.of<HomeProvider>(context).selectedId;
    final friend = friends?.where((f) => f.uid == selectedId).firstOrNull;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        title: const Text('GameParrot'),
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
              color: AppColors.lightBlue,
              child: UserList(),
            ),
          if (!isMobile) Container(width: 5, color: AppColors.darkBlue),
          Expanded(
            child: Column(
              children: [
                if (isMobile && selectedId == null)
                  Expanded(child: UserList())
                else
                  Expanded(
                    child: Stack(
                      children: [
                        Messages(),
                        if (isMobile)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.darkBlue,
                                  Colors.black.withValues(alpha: 0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Provider.of<HomeProvider>(
                                    context,
                                    listen: false,
                                  ).setSelectedId(null),
                                ),
                                Expanded(
                                  child: Text(
                                    friend?.email ?? '',
                                    style: const TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (selectedId != null)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: MessageInput(
                              onSend: sendMessage,
                              backgroundColor: const Color(0xFF0F3460),
                              textColor: Colors.white,
                              hintText: 'Type your message...',
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
