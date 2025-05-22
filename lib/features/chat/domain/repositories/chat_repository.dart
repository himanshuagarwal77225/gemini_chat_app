import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_message.dart';

/// Interface for chat-related repository operations.
abstract class ChatRepository {
  /// Sends a message to the AI and returns its response.
  ///
  /// Returns [Either] with:
  /// - [Failure] if there's an error
  /// - [ChatMessage] containing the AI's response if successful
  Future<Either<Failure, ChatMessage>> sendMessage(String message);

  /// Gets the chat history.
  ///
  /// Returns [Either] with:
  /// - [Failure] if there's an error
  /// - List of [ChatMessage] if successful
  Future<Either<Failure, List<ChatMessage>>> getChatHistory();

  /// Clears the chat history.
  ///
  /// Returns [Either] with:
  /// - [Failure] if there's an error
  /// - void if successful
  Future<Either<Failure, void>> clearHistory();
}
