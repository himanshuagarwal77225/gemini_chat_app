import 'package:equatable/equatable.dart';

/// Base class for all chat-related events.
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

/// Event for sending a message to the AI.
class SendMessageEvent extends ChatEvent {
  /// The message text to send.
  final String message;

  /// Creates a new [SendMessageEvent].
  const SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

/// Event for loading chat history.
class LoadChatHistoryEvent extends ChatEvent {
  const LoadChatHistoryEvent();
}

/// Event for clearing chat history.
class ClearHistoryEvent extends ChatEvent {
  const ClearHistoryEvent();
}
