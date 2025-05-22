import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';

/// Implementation of [ChatRepository] that handles data operations.
class ChatRepositoryImpl implements ChatRepository {
  /// Local data source for chat history
  final ChatLocalDataSource localDataSource;

  /// Remote data source for AI communication
  final ChatRemoteDataSource remoteDataSource;

  final NetworkInfo networkInfo;

  /// Creates a new [ChatRepositoryImpl] instance.
  ///
  /// Parameters:
  ///   - localDataSource: The data source for local storage operations.
  ///   - remoteDataSource: The data source for AI communication.
  ///   - networkInfo: The network information for checking internet connection.
  ChatRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatHistory() async {
    try {
      final messages = await localDataSource.getCachedMessages();
      return Right(messages);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ChatMessage>> sendMessage(String message) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final remoteMessage = await remoteDataSource.sendMessage(message);
      await localDataSource.cacheMessage(remoteMessage);
      return Right(remoteMessage);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await localDataSource.clearCachedMessages();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
