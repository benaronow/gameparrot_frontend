import 'package:flutter/material.dart';
import '../user_list.dart';
import 'sidebar.dart';
import 'chat_area.dart';

class HomeLayout extends StatelessWidget {
  final bool isMobile;
  final String? selectedId;
  final String? friendEmail;
  final Function(String, String, String) onSend;

  const HomeLayout({
    super.key,
    required this.isMobile,
    required this.selectedId,
    this.friendEmail,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isMobile) const Sidebar(),
        Expanded(
          child: Column(
            children: [
              if (isMobile && selectedId == null)
                Expanded(child: UserList())
              else
                ChatArea(
                  isMobile: isMobile,
                  selectedId: selectedId,
                  friendEmail: friendEmail,
                  onSend: onSend,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
