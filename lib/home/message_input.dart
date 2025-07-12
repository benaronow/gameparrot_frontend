import 'package:flutter/material.dart';
import 'package:gameparrot/providers/home_provider.dart';
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
  bool isComposing = false;

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
    final setSelectedId = Provider.of<HomeProvider>(context).setSelectedId;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setSelectedId(null),
            child: Container(
              decoration: BoxDecoration(
                color: isComposing
                    ? const Color(0xFF53354A)
                    : const Color(0xFF3A3A50),
                shape: BoxShape.circle,
                boxShadow: isComposing
                    ? [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.5),
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
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (text) =>
                  setState(() => isComposing = text.trim().isNotEmpty),
              onSubmitted: (_) => _handleSubmitted(),
              style: TextStyle(color: widget.textColor),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: widget.textColor.withOpacity(0.5)),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isComposing ? 1.0 : 0.4,
            child: GestureDetector(
              onTap: isComposing ? _handleSubmitted : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isComposing
                      ? const Color(0xFF53354A)
                      : const Color(0xFF3A3A50),
                  shape: BoxShape.circle,
                  boxShadow: isComposing
                      ? [
                          BoxShadow(
                            color: Colors.pinkAccent.withOpacity(0.5),
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
        ],
      ),
    );
  }
}
