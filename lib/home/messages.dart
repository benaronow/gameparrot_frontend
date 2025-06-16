import 'package:flutter/material.dart';
import 'package:gameparrot/models/user.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:gameparrot/providers/users_provider.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Scroll after build to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);

    final friends = usersProvider.currentUser?.friends ?? [];
    final friend = friends.firstWhere(
      (f) => f.uid == homeProvider.selectedId,
      orElse: () => Friend(uid: '', messages: []),
    );
    final messages = friend.messages;

    final currentUserId = Provider.of<FirebaseAuthProvider>(context).uid;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return homeProvider.selectedId == null
        ? const Center(
            child: Text(
              "Select a user to chat with",
              style: TextStyle(color: Colors.white70),
            ),
          )
        : Column(
            children: [
              if (isMobile)
                Container(
                  color: const Color(0xFF0F3460),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => homeProvider.setSelectedId(null),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        usersProvider.users
                                ?.firstWhere(
                                  (u) => u.uid == homeProvider.selectedId,
                                )
                                .email ??
                            "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Container(
                  color: const Color(0xFF1A1A2E),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final data = messages[index];
                      final isMe = data.from == currentUserId;

                      return AnimatedMessage(
                        key: ValueKey(data.message),
                        message: data.message,
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
              color: widget.isMe
                  ? const Color(0xFF0F3460)
                  : const Color(0xFF53354A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              widget.message,
              style: TextStyle(
                color: widget.isMe ? Colors.white : Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
