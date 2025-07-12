import 'package:flutter/material.dart';
import 'package:gameparrot/theme.dart';
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
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              onTap: () => homeProvider.setSelectedId(user.uid),
              leading: CircleAvatar(
                backgroundColor: user.online
                    ? Colors.green
                    : Theme.of(context).colorScheme.onSurface,
                child: Text(
                  user.email[0].toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(color: AppColors.white),
                ),
              ),
              title: Text(
                user.email,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                user.online ? "Online" : "Offline",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: user.online
                      ? Colors.green
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
