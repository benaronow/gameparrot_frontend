import 'package:flutter/material.dart';
import 'package:gameparrot/theme.dart';
import 'components/components.dart';
import 'services/services.dart';

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
    WebSocketService.dispose(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeData = HomeDataController.getHomeData(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GameParrotAppBar(),
      body: HomeLayout(
        isMobile: homeData.isMobile,
        selectedId: homeData.selectedId,
        friendEmail: homeData.selectedFriend?.email,
        onSend: homeData.sendMessage,
      ),
    );
  }
}
