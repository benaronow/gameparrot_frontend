import 'package:flutter/material.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/theme.dart';
import 'package:provider/provider.dart';
import 'package:gameparrot/providers/auth_provider.dart';

class MessageInput extends StatefulWidget {
  final void Function(String message, String from, String to) onSend;
  final Color backgroundColor;
  final Color textColor;
  final String hintText;

  const MessageInput({
    super.key,
    required this.onSend,
    required this.backgroundColor,
    required this.textColor,
    required this.hintText,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted() {
    final currentUserId = Provider.of<FirebaseAuthProvider>(
      context,
      listen: false,
    ).uid;
    final selectedId = Provider.of<HomeProvider>(
      context,
      listen: false,
    ).selectedId;

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text, currentUserId!, selectedId!);
    _controller.clear();
    setState(() => isComposing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0),
            Colors.black.withValues(alpha: 0.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.text,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (text) =>
                    setState(() => isComposing = text.trim().isNotEmpty),
                onSubmitted: (_) => _handleSubmitted(),
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: widget.textColor.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          MouseRegion(
            cursor: isComposing
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isComposing ? _handleSubmitted : null,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isComposing ? 1.0 : 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                    boxShadow: isComposing
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
