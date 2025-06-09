import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final void Function(String) onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Enter message',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _send(),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _send,
          child: const Text('Send to Go Server'),
        ),
      ],
    );
  }
}
