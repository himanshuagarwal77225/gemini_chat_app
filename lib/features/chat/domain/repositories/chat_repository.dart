import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_message.dart';

/// Abstract class defining the contract for chat-related operations.
///
/// This repository interface defines the contract for all chat-related data operations,
/// including sending messages to the AI, managing chat history, and clearing conversations.
/// It uses the Either type from dartz for proper error handling.
abstract class ChatRepository {
  /// Sends a message to the AI and returns either a [Failure] or a [ChatMessage].
  ///
  /// This method handles the communication with the AI service and returns
  /// either the AI's response as a [ChatMessage] or a [Failure] if something goes wrong.
  ///
  /// Parameters:
  ///   - message: The text message to send to the AI.
  ///
  /// Returns:
  ///   A [Future] that completes with [Either] a [Failure] or a [ChatMessage].
  Future<Either<Failure, ChatMessage>> sendMessage(String message);

  /// Retrieves the chat history from local storage.
  ///
  /// This method fetches all previously stored messages between the user and AI.
  ///
  /// Returns:
  ///   A [Future] that completes with [Either] a [Failure] or a [List] of [ChatMessage].
  Future<Either<Failure, List<ChatMessage>>> getChatHistory();

  /// Clears all stored chat history.
  ///
  /// This method removes all stored messages from local storage.
  ///
  /// Returns:
  ///   A [Future] that completes with [Either] a [Failure] or void on success.
  Future<Either<Failure, void>> clearHistory();
}
