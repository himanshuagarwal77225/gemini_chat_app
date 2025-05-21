import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message.dart';

/// Base class for all chat-related states in the application.
///
/// This abstract class serves as the foundation for all possible states
/// that the chat feature can be in. It extends [Equatable] to provide
/// value equality comparisons between states.
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

/// Represents the initial state of the chat feature.
///
/// This state is used when the chat feature is first initialized
/// and no messages have been loaded yet.
class ChatInitial extends ChatState {}

/// Represents a loading state while performing chat operations.
///
/// This state is used when the application is waiting for operations
/// such as loading chat history or sending messages.
class ChatLoading extends ChatState {}

/// Represents an error state in the chat feature.
///
/// This state is used when an operation fails and contains
/// an error message describing what went wrong.
class ChatError extends ChatState {
  /// The error message describing what went wrong.
  final String message;

  /// Creates a new [ChatError] state.
  ///
  /// Parameters:
  ///   - message: A description of the error that occurred.
  const ChatError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Represents a state where chat messages are loaded and ready.
///
/// This state contains the list of chat messages and a flag indicating
/// whether the AI is currently typing a response.
class ChatMessagesLoaded extends ChatState {
  /// The list of chat messages to display.
  final List<ChatMessage> messages;

  /// Whether the AI is currently typing a response.
  final bool isTyping;

  /// Creates a new [ChatMessagesLoaded] state.
  ///
  /// Parameters:
  ///   - messages: The list of chat messages to display.
  ///   - isTyping: Whether the AI is currently typing (defaults to false).
  const ChatMessagesLoaded({
    required this.messages,
    this.isTyping = false,
  });

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
