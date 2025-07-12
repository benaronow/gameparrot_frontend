import 'package:flutter/material.dart';
import 'package:gameparrot/home/account_dialog/account_dialog.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:gameparrot/theme.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class GameParrotAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GameParrotAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(context);

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(color: AppColors.darkBlue),
        child: AppBar(
          backgroundColor: AppColors.darkBlue,
          elevation: 0,
          title: Text(
            'GameParrot',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
          actions: [
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: StyledIconButton(
                  icon: Icons.account_circle,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  iconColor: Colors.white,
                  size: 40,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider.value(
                          value: Provider.of<UsersProvider>(
                            context,
                            listen: false,
                          ),
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: StyledIconButton(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                icon: Icons.logout,
                iconColor: Colors.white,
                size: 40,
                onPressed: authProvider.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
