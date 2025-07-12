import 'package:flutter/material.dart';
import 'package:gameparrot/models/user.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';

/// Controller for managing home screen data operations
class HomeDataController {
  static HomeData getHomeData(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    final friendIds = usersProvider.currentUser?.friends?.map((f) => f.uid);
    final friends = usersProvider.users
        ?.where((u) => friendIds?.contains(u.uid) ?? false)
        .toList();

    final selectedId = homeProvider.selectedId;
    final selectedFriend = friends
        ?.where((f) => f.uid == selectedId)
        .firstOrNull;

    final sendMessage = Provider.of<UsersProvider>(
      context,
      listen: false,
    ).sendMessage;

    final isMobile = MediaQuery.of(context).size.width < 600;

    return HomeData(
      friends: friends ?? [],
      selectedFriend: selectedFriend,
      selectedId: selectedId,
      sendMessage: sendMessage,
      isMobile: isMobile,
    );
  }
}

/// Data class containing all the processed data needed for the home screen
class HomeData {
  final List<User> friends;
  final User? selectedFriend;
  final String? selectedId;
  final Function(String, String, String?) sendMessage;
  final bool isMobile;

  const HomeData({
    required this.friends,
    this.selectedFriend,
    this.selectedId,
    required this.sendMessage,
    required this.isMobile,
  });
}
