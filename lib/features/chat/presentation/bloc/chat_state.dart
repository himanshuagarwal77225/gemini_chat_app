import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message.dart';

/// Base class for all chat-related states in the application.
///
/// This abstract class serves as the foundation for all possible states
/// that the chat feature can be in. It extends [Equatable] to provide
/// value equality comparisons between states.
abstract class ChatState extends Equatable {
  /// The current list of chat messages.
  final List<ChatMessage> messages;

  /// Creates a new [ChatState].
  const ChatState(this.messages);

  @override
  List<Object> get props => [messages];
}

/// Represents the initial state of the chat feature.
///
/// This state is used when the chat feature is first initialized
/// and no messages have been loaded yet.
class ChatInitial extends ChatState {
  /// Creates a new [ChatInitial] state.
  const ChatInitial(super.messages);
}

/// Represents a loading state while performing chat operations.
///
/// This state is used when the application is waiting for operations
/// such as loading chat history or sending messages.
class ChatLoading extends ChatState {
  /// Creates a new [ChatLoading] state.
  const ChatLoading(super.messages);
}

/// Represents a state where chat messages are loaded and ready.
///
/// This state contains the list of chat messages and a flag indicating
/// whether the AI is currently typing a response.
class ChatMessagesLoaded extends ChatState {
  /// The list of chat messages to display.
  final List<ChatMessage> _messages;

  /// The list of chat messages to display.
  @override
  List<ChatMessage> get messages => _messages;

  /// Whether the AI is currently typing a response.
  final bool isTyping;

  /// Creates a new [ChatMessagesLoaded] state.
  ///
  /// Parameters:
  ///   - messages: The list of chat messages to display.
  ///   - isTyping: Whether the AI is currently typing (defaults to false).
  const ChatMessagesLoaded({
    required List<ChatMessage> messages,
    this.isTyping = false,
  })  : _messages = messages,
        super(messages);

  @override
  List<Object> get props => [messages, isTyping];

  /// Creates a copy of this state with optional parameter updates.
  ///
  /// Parameters:
  ///   - messages: Optional new list of messages.
  ///   - isTyping: Optional new typing status.
  ///
  /// Returns:
  ///   A new [ChatMessagesLoaded] instance with updated values.
  ChatMessagesLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
  }) {
    return ChatMessagesLoaded(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

/// Represents a state where a chat message has been sent.
class ChatMessageSent extends ChatState {
  /// Creates a new [ChatMessageSent] state.
  const ChatMessageSent(super.messages);
}

/// Represents an error state in the chat feature.
///
/// This state is used when an operation fails and contains
/// an error message describing what went wrong.
class ChatError extends ChatState {
  /// The error message describing what went wrong.
  final String error;

  /// Creates a new [ChatError] state.
  ///
  /// Parameters:
  ///   - messages: The list of chat messages.
  ///   - error: A description of the error that occurred.
  const ChatError(super.messages, this.error);

  @override
  List<Object> get props => [messages, error];
}
