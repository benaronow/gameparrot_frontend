import 'package:flutter/material.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:gameparrot/theme.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _scrollController = ScrollController();
  String? _lastMessageKey;

  String _getMessageKey(dynamic msg) {
    return '${msg.from}_${msg.to}_${msg.message}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);

    final friends = usersProvider.currentUser?.friends ?? [];
    final selectedId = homeProvider.selectedId;

    final friend = friends.where((f) => f.uid == selectedId).isNotEmpty
        ? friends.firstWhere((f) => f.uid == selectedId)
        : null;

    if (selectedId == null || friend == null) {
      return const Center(child: Text('Select a conversation'));
    }

    final messages = friend.messages;
    final currentUserId = Provider.of<FirebaseAuthProvider>(context).uid;

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              padding: const EdgeInsets.only(bottom: 8),
              itemBuilder: (ctx, idx) {
                final msg = messages[idx];
                final isMe = msg.from == currentUserId;
                final messageKey = _getMessageKey(msg);
                final isNewMessage = idx == messages.length - 1 && 
                    _lastMessageKey != messageKey;

                // Update the last message key when we render a new message
                if (isNewMessage) {
                  _lastMessageKey = messageKey;
                }

                if (isNewMessage) {
                  return SlideMessageBubble(
                    key: ValueKey(messageKey),
                    message: msg.message,
                    isMe: isMe,
                  );
                }

                return MessageBubble(
                  key: ValueKey(messageKey),
                  message: msg.message,
                  isMe: isMe,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.65;
    final theme = Theme.of(context);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        decoration: BoxDecoration(
          color: isMe ? AppColors.bubbleMe : AppColors.bubbleOther,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: isMe
                ? AppColors.textOnPrimary
                : AppColors.textOnBubbleOther,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class SlideMessageBubble extends StatefulWidget {
  final String message;
  final bool isMe;

  const SlideMessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  State<SlideMessageBubble> createState() => _SlideMessageBubbleState();
}

class _SlideMessageBubbleState extends State<SlideMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    final beginOffset = widget.isMe ? const Offset(1, 0) : const Offset(-1, 0);
    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: MessageBubble(
        message: widget.message,
        isMe: widget.isMe,
      ),
    );
  }
}
