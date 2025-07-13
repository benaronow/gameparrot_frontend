import 'package:flutter/material.dart';
import 'package:gameparrot/theme.dart';
import 'package:gameparrot/models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final bool isSelected;
  final VoidCallback onTap;

  const UserListItem({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  AppColors.accentBlue,
                  AppColors.accentBlue.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppColors.darkBlue.withValues(alpha: 0.6),
                  AppColors.darkBlue.withValues(alpha: 0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.accentBlue.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 1,
                  offset: const Offset(0, -1),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: user.online
                    ? Colors.green.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: user.online ? Colors.green : AppColors.darkGray,
            child: Text(
              user.email[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        title: Text(
          user.email,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        subtitle: Text(
          user.online ? "Online" : "Offline",
          style: TextStyle(
            color: user.online ? Colors.greenAccent : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.2),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
        ),
        trailing: isSelected
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              )
            : null,
      ),
    );
  }
}
