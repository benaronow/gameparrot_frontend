import 'package:flutter/material.dart';
import '../messages/messages.dart';
import '../message_input.dart';
import 'mobile_header.dart';

class ChatArea extends StatelessWidget {
  final bool isMobile;
  final String? selectedId;
  final String? friendEmail;
  final Function(String, String, String) onSend;

  const ChatArea({
    super.key,
    required this.isMobile,
    required this.selectedId,
    this.friendEmail,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Messages(),
          if (isMobile) MobileHeader(friendEmail: friendEmail),
          if (selectedId != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MessageInput(
                onSend: onSend,
                textColor: Colors.white,
                hintText: 'Type your message...',
              ),
            ),
        ],
      ),
    );
  }
}
