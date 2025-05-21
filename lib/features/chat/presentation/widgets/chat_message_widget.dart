import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/chat_message.dart';

/// Widget that displays a single chat message.
///
/// This widget renders a chat message bubble with different styles for
/// user and AI messages. It includes the message content, timestamp,
/// and an avatar icon to distinguish between participants.
class ChatMessageWidget extends StatelessWidget {
  /// The chat message to display.
  final ChatMessage message;

  /// Creates a new [ChatMessageWidget] instance.
  ///
  /// Parameters:
  ///   - message: The [ChatMessage] to display.
  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // AI avatar (shown on the left for AI messages)
          if (!message.isUser) _buildAvatar(),
          const SizedBox(width: 8),
          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message content
                  Text(
                    message.content,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Timestamp
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: message.isUser
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // User avatar (shown on the right for user messages)
          if (message.isUser) _buildAvatar(),
        ],
      ),
    );
  }

  /// Builds an avatar icon for the message sender.
  ///
  /// Returns a [CircleAvatar] with different colors and icons
  /// for user and AI messages.
  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: message.isUser ? Colors.blue : Colors.green,
      child: Icon(
        message.isUser ? Icons.person : Icons.android,
        color: Colors.white,
      ),
    );
  }
}
