import 'package:flutter/material.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MessageInput extends StatefulWidget {
  final void Function(String, String) onSend;

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

  void _send(String uid) {
    final text = _controller.text.trim();
    if (text.isNotEmpty && uid.isNotEmpty) {
      widget.onSend(text, uid);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(context);

    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Enter message',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => {_send(authProvider.uid ?? "")},
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _send(authProvider.uid ?? ""),
          child: const Text('Send to Go Server'),
        ),
      ],
    );
  }
}
