import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

/// Use case for sending a message to the AI.
///
/// This class implements the business logic for sending messages to the AI.
/// It validates the input and delegates the actual sending to the repository.
/// Following clean architecture principles, this use case is independent of
/// the data layer implementation.
class SendMessage {
  /// The repository that handles the actual message sending.
  final ChatRepository repository;

  /// Creates a new [SendMessage] use case instance.
  ///
  /// Parameters:
  ///   - repository: The [ChatRepository] implementation to use.
  SendMessage(this.repository);

  /// Executes the use case to send a message to the AI.
  ///
  /// This method validates the message and delegates to the repository
  /// for sending. It ensures that empty messages are not sent to the AI.
  ///
  /// Parameters:
  ///   - message: The text message to send to the AI.
  ///
  /// Returns:
  ///   A [Future] that completes with [Either] a [Failure] or a [ChatMessage]
  ///   containing the AI's response.
  Future<Either<Failure, ChatMessage>> execute(String message) async {
    // Validate message is not empty
    if (message.trim().isEmpty) {
      return const Left(ServerFailure(message: 'Message cannot be empty'));
    }
    return repository.sendMessage(message);
  }
}
