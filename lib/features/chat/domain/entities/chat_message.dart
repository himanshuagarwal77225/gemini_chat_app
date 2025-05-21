import 'package:equatable/equatable.dart';

/// Represents a chat message in the application.
///
/// This class is the core entity for chat messages, containing the message content,
/// sender information (user or AI), and timestamp. It extends [Equatable] to provide
/// value equality comparisons.
class ChatMessage extends Equatable {
  /// The content of the message.
  final String content;

  /// Whether the message was sent by the user (true) or AI (false).
  final bool isUser;

  /// The timestamp when the message was created.
  final DateTime timestamp;

  /// Creates a new [ChatMessage] instance.
  ///
  /// Parameters:
  ///   - content: The text content of the message.
  ///   - isUser: Whether the message was sent by the user.
  ///   - timestamp: When the message was created.
  const ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  @override
  List<Object> get props => [content, isUser, timestamp];

  /// Creates a user message with the current timestamp.
  ///
  /// Parameters:
  ///   - content: The text content of the user's message.
  ///
  /// Returns:
  ///   A new [ChatMessage] instance representing a user message.
  factory ChatMessage.user({required String content}) {
    return ChatMessage(
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
  }

  /// Creates an AI message with the current timestamp.
  ///
  /// Parameters:
  ///   - content: The text content of the AI's response.
  ///
  /// Returns:
  ///   A new [ChatMessage] instance representing an AI message.
  factory ChatMessage.ai({required String content}) {
    return ChatMessage(
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
