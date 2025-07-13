import 'package:flutter/material.dart';
import 'package:gameparrot/home/home_data_model.dart';
import 'package:gameparrot/theme.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'list_item.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final homeData = HomeDataModel.getHomeData(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkBlue.withValues(alpha: 0.8),
            AppColors.darkBlue.withValues(alpha: 0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: (homeData.friends.isEmpty)
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.people_outline,
                        color: Colors.white,
                        size: 32,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No Friends Yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add friends to start chatting',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: homeData.friends.length,
              itemBuilder: (context, index) {
                final user = homeData.friends[index];
                final isSelected = user.uid == homeProvider.selectedId;

                return UserListItem(
                  user: user,
                  isSelected: isSelected,
                  onTap: () => homeProvider.setSelectedId(user.uid),
                );
              },
            ),
    );
  }
}
