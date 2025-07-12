import 'package:flutter/material.dart';
import 'message_bubble.dart';
import 'select_conversation.dart';
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
      return const SelectConversation();
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
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: messages.length + 1,
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
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
