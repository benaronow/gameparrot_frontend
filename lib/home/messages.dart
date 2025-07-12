import 'package:flutter/material.dart';
import 'package:gameparrot/theme.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _scrollController = ScrollController();

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
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (ctx, idx) {
                final msg = messages[idx];
                final isMe = msg.from == currentUserId;
                return AnimatedMessage(
                  key: ValueKey(msg.from + msg.message + idx.toString()),
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

class AnimatedMessage extends StatefulWidget {
  final String message;
  final bool isMe;

  const AnimatedMessage({
    required Key key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  State<AnimatedMessage> createState() => _AnimatedMessageState();
}

class _AnimatedMessageState extends State<AnimatedMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

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

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.65;
    final theme = Theme.of(context);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Align(
          alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: maxBubbleWidth),
            decoration: BoxDecoration(
              color: widget.isMe ? AppColors.bubbleMe : AppColors.bubbleOther,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              widget.message,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: widget.isMe
                    ? AppColors.textOnPrimary
                    : AppColors.textOnBubbleOther,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
