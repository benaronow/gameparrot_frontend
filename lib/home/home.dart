import 'package:flutter/material.dart';
import 'package:gameparrot/home/messages/messages.dart';
import 'package:gameparrot/home/sidebar.dart';
import 'package:gameparrot/home/user_list/user_list.dart';
import 'app_bar.dart';
import 'package:gameparrot/theme.dart';
import '../services/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WebSocketService.initialize(context);
  }

  @override
  void dispose() {
    WebSocketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeData = HomeDataModel.getHomeData(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GameParrotAppBar(),
      body: Row(
        children: [
          if (!homeData.isMobile) const Sidebar(),
          Expanded(
            child: Column(
              children: [
                if (homeData.isMobile && homeData.selectedFriend == null)
                  Expanded(child: UserList())
                else
                  Messages(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
