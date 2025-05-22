import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

/// Use case for sending a message to the AI and getting a response.
///
/// This class implements the business logic for sending messages to the AI.
/// It validates the input and delegates the actual sending to the repository.
/// Following clean architecture principles, this use case is independent of
/// the data layer implementation.
class SendMessage {
  /// The repository that handles the actual message sending.
  final ChatRepository repository;

  /// Creates a new [SendMessage] use case.
  ///
  /// Parameters:
  ///   - repository: The chat repository to use for sending messages.
  SendMessage(this.repository);

  /// Executes the use case with the given message.
  ///
  /// Parameters:
  ///   - message: The message text to send to the AI.
  ///
  /// Returns:
  ///   A [Future] that resolves to an [Either] containing either a
  ///   [Failure] if the operation failed, or a [ChatMessage] containing
  ///   the AI's response if successful.
  Future<Either<Failure, ChatMessage>> execute(String message) async {
    if (message.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Message cannot be empty'));
    }
    return await repository.sendMessage(message);
  }

  /// Callable class method, allows the class to be called like a function.
  ///
  /// This is a convenience method that calls [execute].
  Future<Either<Failure, ChatMessage>> call(String message) async {
    return execute(message);
  }
}
