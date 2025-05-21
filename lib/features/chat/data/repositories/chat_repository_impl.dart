import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_message_model.dart';

/// Implementation of the [ChatRepository] interface.
///
/// This class implements the chat repository interface by combining
/// remote data source (Gemini AI) with local storage (SharedPreferences)
/// to provide a complete chat functionality with message history.
class ChatRepositoryImpl implements ChatRepository {
  /// Remote data source for AI communication
  final ChatRemoteDataSource remoteDataSource;

  /// Local storage for chat history
  final SharedPreferences sharedPreferences;

  /// Key used to store chat history in SharedPreferences
  static const String chatHistoryKey = 'chat_history';

  /// Creates a new [ChatRepositoryImpl] instance.
  ///
  /// Parameters:
  ///   - remoteDataSource: The data source for AI communication.
  ///   - sharedPreferences: Local storage instance for chat history.
  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, ChatMessage>> sendMessage(String message) async {
    try {
      // Save user message to history
      final userMessage = ChatMessageModel.user(content: message);
      await _saveMessage(userMessage);

      // Get AI response
      final response = await remoteDataSource.sendMessage(message);
      await _saveMessage(response);

      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatHistory() async {
    try {
      // Retrieve chat history from local storage
      final jsonString = sharedPreferences.getString(chatHistoryKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        final messages =
            jsonList.map((json) => ChatMessageModel.fromJson(json)).toList();
        return Right(messages);
      }
      return const Right([]);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await sharedPreferences.remove(chatHistoryKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  /// Saves a message to the local chat history.
  ///
  /// This method appends the new message to the existing chat history
  /// and saves it to SharedPreferences.
  ///
  /// Parameters:
  ///   - message: The [ChatMessageModel] to save.
  Future<void> _saveMessage(ChatMessageModel message) async {
    final messages = await getChatHistory();
    final currentMessages = messages.fold(
      (failure) => <ChatMessageModel>[],
      (messages) => messages.map((m) => m as ChatMessageModel).toList(),
    );

    currentMessages.add(message);
    final jsonString = json.encode(
      currentMessages.map((m) => m.toJson()).toList(),
    );
    await sharedPreferences.setString(chatHistoryKey, jsonString);
  }
}
