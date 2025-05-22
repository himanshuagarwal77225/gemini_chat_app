import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

/// BLoC (Business Logic Component) for managing chat state and operations.
///
/// This class handles the business logic for the chat feature, including
/// sending messages, loading chat history, and clearing history. It uses
/// the BLoC pattern to manage state and handle events.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  /// Use case for sending messages to the AI.
  final SendMessage sendMessage;

  /// Repository for chat-related operations.
  final ChatRepository repository;

  /// Creates a new [ChatBloc] instance.
  ///
  /// Parameters:
  ///   - sendMessage: Use case for sending messages.
  ///   - repository: Repository for chat operations.
  ChatBloc({
    required this.sendMessage,
    required this.repository,
  }) : super(const ChatInitial([])) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadChatHistoryEvent>(_onLoadChatHistory);
    on<ClearHistoryEvent>(_onClearHistory);
  }

  /// Handles the [SendMessageEvent].
  ///
  /// This method processes the sending of a message to the AI and
  /// updates the state accordingly. It shows a typing indicator
  /// while waiting for the AI's response.
  ///
  /// Parameters:
  ///   - event: The send message event containing the message text.
  ///   - emit: Function to emit new states.
  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    // Create and add user message immediately
    final userMessage = ChatMessage.user(content: event.message);
    final currentMessages = List<ChatMessage>.from(state.messages)
      ..add(userMessage);
    emit(ChatMessageSent(currentMessages));

    // Show loading state while waiting for AI response
    emit(ChatLoading(currentMessages));

    // Get AI response
    final result = await sendMessage.execute(event.message);
    result.fold(
      (failure) => emit(ChatError(currentMessages, failure.message)),
      (aiMessage) {
        final updatedMessages = List<ChatMessage>.from(currentMessages)
          ..add(aiMessage);
        emit(ChatMessageSent(updatedMessages));
      },
    );
  }

  /// Handles the [LoadChatHistoryEvent].
  ///
  /// This method loads the chat history from storage and updates
  /// the state with the loaded messages.
  ///
  /// Parameters:
  ///   - event: The load history event.
  ///   - emit: Function to emit new states.
  Future<void> _onLoadChatHistory(
    LoadChatHistoryEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading(state.messages));

    final result = await repository.getChatHistory();

    result.fold(
      (failure) => emit(ChatError(state.messages, failure.message)),
      (messages) => emit(ChatInitial(messages)),
    );
  }

  /// Handles the [ClearHistoryEvent].
  ///
  /// This method clears all chat history from storage and updates
  /// the state to show an empty chat.
  ///
  /// Parameters:
  ///   - event: The clear history event.
  ///   - emit: Function to emit new states.
  Future<void> _onClearHistory(
    ClearHistoryEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading(state.messages));

    final result = await repository.clearHistory();

    result.fold(
      (failure) => emit(ChatError(state.messages, failure.message)),
      (_) => emit(const ChatInitial([])),
    );
  }
}
