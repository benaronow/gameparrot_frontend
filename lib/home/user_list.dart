import 'package:flutter/material.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);
    final friendIds = usersProvider.currentUser?.friends?.map((f) => f.uid);
    final friends = usersProvider.users
        ?.where((u) => friendIds?.contains(u.uid) ?? false)
        .toList();

    return ListView.builder(
      itemCount: friends?.length ?? 0,
      itemBuilder: (context, index) {
        final user = friends?[index];
        final isSelected = user?.uid == homeProvider.selectedId;

        if (user != null) {
          return Container(
            color: isSelected ? const Color(0xFF0F3460) : Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              onTap: () => homeProvider.setSelectedId(user.uid),
              leading: CircleAvatar(
                backgroundColor: isSelected
                    ? Colors.blueAccent
                    : user.online
                    ? Colors.green
                    : Colors.grey,
                child: Text(
                  user.email[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                user.email,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow
                    .ellipsis, // or .clip if you don't want ellipsis
                softWrap: false,
                maxLines: 1,
              ),
              subtitle: Text(
                user.online ? "Online" : "Offline",
                style: TextStyle(
                  color: user.online ? Colors.green[300] : Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.arrow_right, color: Colors.white)
                  : null,
            ),
          );
        }
        return const SizedBox.shrink(); // fallback for null user
      },
    );
  }
}
