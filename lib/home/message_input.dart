import 'package:flutter/material.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/theme.dart';
import 'package:provider/provider.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import '../widgets/widgets.dart';

class MessageInput extends StatefulWidget {
  final void Function(String message, String from, String to) onSend;
  final Color textColor;
  final String hintText;

  const MessageInput({
    super.key,
    required this.onSend,
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
        right: 24,
        top: 20,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0),
            AppColors.shadow.withValues(alpha: 0.4),
            AppColors.shadow.withValues(alpha: 0.8),
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: (text) =>
                      setState(() => isComposing = text.trim().isNotEmpty),
                  onSubmitted: (_) => _handleSubmitted(),
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
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
                      borderSide: BorderSide(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          StyledIconButton(
            icon: Icons.send_rounded,
            backgroundColor: isComposing
                ? AppColors.primaryBlue
                : AppColors.primaryBlue.withOpacity(0.5),
            iconColor: Colors.white,
            size: 48,
            onPressed: isComposing ? _handleSubmitted : null,
          ),
        ],
      ),
    );
  }
}
