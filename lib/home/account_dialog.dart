import 'package:flutter/material.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';

class AccountDialog extends StatelessWidget {
  const AccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UsersProvider>(
      context,
      listen: false,
    ).currentUser;

    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(currentUser?.email ?? "Unknown User"),
            const SizedBox(height: 6),
            Text("UID: ${currentUser?.uid ?? "null"}"),
            const SizedBox(height: 20),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text("Friend Requests coming soon..."),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
