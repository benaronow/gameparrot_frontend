import 'package:flutter/material.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';
import '../user_list/list_item.dart';

class NonFriendsList extends StatelessWidget {
  const NonFriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final currentUser = usersProvider.currentUser;
    final allUsers = usersProvider.users ?? [];
    
    // Get friend UIDs for filtering
    final friendIds = currentUser?.friends?.map((f) => f.uid).toSet() ?? <String>{};
    final currentUserId = currentUser?.uid;
    
    // Filter out friends and current user
    final nonFriends = allUsers.where((user) => 
      user.uid != currentUserId && 
      !friendIds.contains(user.uid)
    ).toList();

    if (nonFriends.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.person_search,
              size: 48,
              color: Colors.white.withOpacity(0.6),
            ),
            const SizedBox(height: 12),
            Text(
              'No users to add',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'All available users are already friends',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 200, // Fixed height for the dialog
      child: ListView.builder(
        itemCount: nonFriends.length,
        itemBuilder: (context, index) {
          final user = nonFriends[index];
          return UserListItem(
            user: user,
            isSelected: false, // No selection in this context
            onTap: () {
              // TODO: Implement friend request functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Friend request to ${user.email} - coming soon!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
