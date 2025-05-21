import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

/// Widget that provides the message input interface for the chat.
///
/// This widget displays a text input field and a send button, allowing
/// users to compose and send messages to the AI. It handles text input
/// validation and submission.
class ChatInputWidget extends StatefulWidget {
  /// Creates a new [ChatInputWidget] instance.
  const ChatInputWidget({super.key});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

/// State for the [ChatInputWidget].
///
/// This class manages the state of the text input field and handles
/// the logic for sending messages.
class _ChatInputWidgetState extends State<ChatInputWidget> {
  /// Controller for the text input field.
  final _controller = TextEditingController();

  /// Whether the user is currently composing a message.
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Handles the submission of a message.
  ///
  /// This method validates the message, clears the input field,
  /// and dispatches a [SendMessageEvent] to the chat BLoC.
  ///
  /// Parameters:
  ///   - text: The message text to send.
  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _controller.clear();
    setState(() {
      _isComposing = false;
    });

    context.read<ChatBloc>().add(SendMessageEvent(message: text));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Text input field
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.trim().isNotEmpty;
                    });
                  },
                  onSubmitted: _isComposing ? _handleSubmitted : null,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const SizedBox(width: 8),
              // Send button
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_controller.text)
                    : null,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
