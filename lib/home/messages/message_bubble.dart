import 'package:flutter/material.dart';
import 'package:gameparrot/theme.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isNewMessage;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.isNewMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
          transform: Matrix4.identity()
            ..translate(
              isNewMessage ? (isMe ? 50.0 : -50.0) : 0.0,
              isNewMessage ? 20.0 : 0.0,
            ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primaryBlue : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
