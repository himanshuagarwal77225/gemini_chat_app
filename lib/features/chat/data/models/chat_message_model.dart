import '../../domain/entities/chat_message.dart';

/// Data model class for chat messages.
///
/// This class extends the domain [ChatMessage] entity and adds serialization
/// capabilities for JSON encoding/decoding. It's used for storing messages
/// in local storage and handling API responses.
class ChatMessageModel extends ChatMessage {
  /// Creates a new [ChatMessageModel] instance.
  ///
  /// Parameters:
  ///   - content: The text content of the message.
  ///   - isUser: Whether the message was sent by the user.
  ///   - timestamp: When the message was created.
  const ChatMessageModel({
    required super.content,
    required super.isUser,
    required super.timestamp,
  });

  /// Creates a [ChatMessageModel] from a JSON map.
  ///
  /// Parameters:
  ///   - json: Map containing the message data.
  ///
  /// Returns:
  ///   A new [ChatMessageModel] instance.
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Converts the message to a JSON map.
  ///
  /// Returns:
  ///   A Map containing the message data in JSON format.
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Creates a user message with the current timestamp.
  ///
  /// Parameters:
  ///   - content: The text content of the user's message.
  ///
  /// Returns:
  ///   A new [ChatMessageModel] instance for a user message.
  factory ChatMessageModel.user({required String content}) {
    return ChatMessageModel(
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
  ///   A new [ChatMessageModel] instance for an AI message.
  factory ChatMessageModel.ai({required String content}) {
    return ChatMessageModel(
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
