import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_chat_app/core/error/exceptions.dart';
import 'package:gemini_chat_app/core/error/failures.dart';
import 'package:gemini_chat_app/core/network/network_info.dart';
import 'package:gemini_chat_app/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:gemini_chat_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:gemini_chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:gemini_chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:gemini_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_repository_impl_test.mocks.dart';

@GenerateMocks([
  ChatRemoteDataSource,
  ChatLocalDataSource,
  NetworkInfo,
])
void main() {
  late ChatRepositoryImpl repository;
  late MockChatRemoteDataSource mockRemoteDataSource;
  late MockChatLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    mockLocalDataSource = MockChatLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ChatRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('sendMessage', () {
    const testMessage = 'Hello';
    final testTimestamp = DateTime.now();
    final testMessageModel = ChatMessageModel(
      content: 'Hi there!',
      isUser: false,
      timestamp: testTimestamp,
    );
    final ChatMessage testMessageEntity = testMessageModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.sendMessage(testMessage))
          .thenAnswer((_) async => testMessageModel);
      when(mockLocalDataSource.cacheMessage(testMessageModel))
          .thenAnswer((_) async => {});

      // act
      await repository.sendMessage(testMessage);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.sendMessage(testMessage))
            .thenAnswer((_) async => testMessageModel);
        when(mockLocalDataSource.cacheMessage(testMessageModel))
            .thenAnswer((_) async => {});

        // act
        final result = await repository.sendMessage(testMessage);

        // assert
        verify(mockRemoteDataSource.sendMessage(testMessage));
        expect(result, equals(Right(testMessageEntity)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.sendMessage(testMessage))
            .thenAnswer((_) async => testMessageModel);
        when(mockLocalDataSource.cacheMessage(testMessageModel))
            .thenAnswer((_) async => {});

        // act
        await repository.sendMessage(testMessage);

        // assert
        verify(mockRemoteDataSource.sendMessage(testMessage));
        verify(mockLocalDataSource.cacheMessage(testMessageModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.sendMessage(testMessage))
            .thenThrow(ServerException(message: 'Server error'));

        // act
        final result = await repository.sendMessage(testMessage);

        // assert
        verify(mockRemoteDataSource.sendMessage(testMessage));
        verifyNever(mockLocalDataSource.cacheMessage(any));
        expect(
            result, equals(const Left(ServerFailure(message: 'Server error'))));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return network failure when device is offline', () async {
        // act
        final result = await repository.sendMessage(testMessage);

        // assert
        verifyNever(mockRemoteDataSource.sendMessage(any));
        expect(
            result,
            equals(
                const Left(NetworkFailure(message: 'No internet connection'))));
      });
    });
  });

  group('getChatHistory', () {
    final testMessageModels = [
      ChatMessageModel(
        content: 'Hello',
        isUser: true,
        timestamp: DateTime.now(),
      ),
      ChatMessageModel(
        content: 'Hi there!',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
    final List<ChatMessage> testMessages = testMessageModels;

    test('should return cached messages when they are present', () async {
      // arrange
      when(mockLocalDataSource.getCachedMessages())
          .thenAnswer((_) async => testMessageModels);

      // act
      final result = await repository.getChatHistory();

      // assert
      verify(mockLocalDataSource.getCachedMessages());
      verifyNever(mockRemoteDataSource.sendMessage(any));
      expect(result, equals(Right(testMessages)));
    });

    test('should return CacheFailure when there is no cached data', () async {
      // arrange
      when(mockLocalDataSource.getCachedMessages())
          .thenThrow(CacheException('No cached messages found'));

      // act
      final result = await repository.getChatHistory();

      // assert
      verify(mockLocalDataSource.getCachedMessages());
      expect(
          result,
          equals(
              const Left(CacheFailure(message: 'No cached messages found'))));
    });
  });

  group('clearHistory', () {
    test('should clear cached messages successfully', () async {
      // arrange
      when(mockLocalDataSource.clearCachedMessages())
          .thenAnswer((_) async => {});

      // act
      final result = await repository.clearHistory();

      // assert
      verify(mockLocalDataSource.clearCachedMessages());
      expect(result, equals(const Right(null)));
    });

    test('should return CacheFailure when clearing cache fails', () async {
      // arrange
      when(mockLocalDataSource.clearCachedMessages())
          .thenThrow(CacheException('Failed to clear cache'));

      // act
      final result = await repository.clearHistory();

      // assert
      verify(mockLocalDataSource.clearCachedMessages());
      expect(result,
          equals(const Left(CacheFailure(message: 'Failed to clear cache'))));
    });
  });
}
