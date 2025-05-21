import 'package:equatable/equatable.dart';

/// Base class for all chat-related events in the application.
///
/// This abstract class serves as the foundation for all events that can
/// be dispatched to the chat BLoC. It extends [Equatable] to provide
/// value equality comparisons between events.
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched when sending a new message to the AI.
///
/// This event is triggered when the user sends a message and contains
/// the message text to be sent to the AI.
class SendMessageEvent extends ChatEvent {
  /// The message text to send to the AI.
  final String message;

  /// Creates a new [SendMessageEvent].
  ///
  /// Parameters:
  ///   - message: The text message to send to the AI.
  const SendMessageEvent({required this.message});

  @override
  List<Object> get props => [message];
}

/// Event dispatched to load the chat history.
///
/// This event is triggered when the chat screen is first loaded
/// or when a refresh of the chat history is needed.
class LoadChatHistoryEvent extends ChatEvent {}

/// Event dispatched to clear the chat history.
///
/// This event is triggered when the user wants to delete
/// all chat messages from the history.
class ClearChatHistoryEvent extends ChatEvent {}
