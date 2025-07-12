import 'package:flutter/material.dart';
import 'message_bubble.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _scrollController = ScrollController();
  int _previousMessageCount = 0;

  String _getMessageKey(dynamic msg) {
    return '${msg.from}_${msg.to}_${msg.message}';
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels == 0) {
      _scrollController.jumpTo(50);
    }

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final homeProvider = Provider.of<HomeProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);
    final selectedId = homeProvider.selectedId;
    final friends = usersProvider.currentUser?.friends ?? [];
    final friend = friends.where((f) => f.uid == selectedId).firstOrNull;
    final currentMessageCount = friend?.messages.length ?? 0;

    if (currentMessageCount > _previousMessageCount) {
      _previousMessageCount = currentMessageCount;
      _scrollToBottom();
    }
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
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.7),
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                    shadows: [
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select a conversation',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a friend to start chatting',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade500,
                    shadows: [
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        offset: const Offset(0, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final messages = friend.messages;
    final currentUserId = Provider.of<FirebaseAuthProvider>(context).uid;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _unfocusKeyboard,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: messages.length + 1,
                padding: const EdgeInsets.only(top: 8),
                itemBuilder: (ctx, idx) {
                  if (idx == 0) {
                    return const SizedBox(height: 90);
                  }
                  final msgIdx = messages.length - idx;
                  final msg = messages[msgIdx];
                  final isMe = msg.from == currentUserId;
                  final messageKey = _getMessageKey(msg);

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
      ),
    );
  }
}
