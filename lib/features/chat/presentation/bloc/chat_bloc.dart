import 'package:flutter_bloc/flutter_bloc.dart';

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
  }) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadChatHistoryEvent>(_onLoadChatHistory);
    on<ClearChatHistoryEvent>(_onClearChatHistory);
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
    if (state is ChatMessagesLoaded) {
      final currentState = state as ChatMessagesLoaded;
      emit(currentState.copyWith(isTyping: true));

      final result = await sendMessage.execute(event.message);

      result.fold(
        (failure) => emit(ChatError(message: failure.message)),
        (message) {
          final updatedMessages = List.of(currentState.messages)..add(message);
          emit(ChatMessagesLoaded(
            messages: updatedMessages,
            isTyping: false,
          ));
        },
      );
    }
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
    emit(ChatLoading());
    final result = await repository.getChatHistory();

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (messages) => emit(ChatMessagesLoaded(messages: messages)),
    );
  }

  /// Handles the [ClearChatHistoryEvent].
  ///
  /// This method clears all chat history from storage and updates
  /// the state to show an empty chat.
  ///
  /// Parameters:
  ///   - event: The clear history event.
  ///   - emit: Function to emit new states.
  Future<void> _onClearChatHistory(
    ClearChatHistoryEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await repository.clearHistory();

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) => emit(const ChatMessagesLoaded(messages: [])),
    );
  }
}
