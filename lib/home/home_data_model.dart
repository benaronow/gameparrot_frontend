import 'package:flutter/material.dart';
import 'package:gameparrot/models/user.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';

class HomeDataModel {
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

    final isMobile = MediaQuery.of(context).size.width < 600;

    return HomeData(
      friends: friends ?? [],
      selectedFriend: selectedFriend,
      isMobile: isMobile,
    );
  }
}

class HomeData {
  final List<User> friends;
  final User? selectedFriend;
  final bool isMobile;

  const HomeData({
    required this.friends,
    this.selectedFriend,
    required this.isMobile,
  });
}
