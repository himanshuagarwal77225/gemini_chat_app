import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_chat_app/core/error/exceptions.dart';
import 'package:gemini_chat_app/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:gemini_chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_local_data_source_test.mocks.dart';

const cachedMessagesKey = 'CACHED_MESSAGES';

@GenerateMocks([], customMocks: [
  MockSpec<SharedPreferences>(as: #MockSharedPreferencesTest),
])
void main() {
  late ChatLocalDataSourceImpl dataSource;
  late MockSharedPreferencesTest mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferencesTest();
    dataSource =
        ChatLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getCachedMessages', () {
    final testTimestamp = DateTime.now();
    final testMessageModels = [
      ChatMessageModel(
        content: 'Hello',
        isUser: true,
        timestamp: testTimestamp,
      ),
      ChatMessageModel(
        content: 'Hi there!',
        isUser: false,
        timestamp: testTimestamp,
      ),
    ];
    final String testMessagesJson = json.encode(
      testMessageModels.map((model) => model.toJson()).toList(),
    );

    test(
        'should return List<ChatMessageModel> from SharedPreferences when there is cached data',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(testMessagesJson);

      // act
      final result = await dataSource.getCachedMessages();

      // assert
      verify(mockSharedPreferences.getString(cachedMessagesKey));
      expect(result, equals(testMessageModels));
    });

    test('should throw CacheException when there is no cached data', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = dataSource.getCachedMessages;

      // assert
      expect(
          () => call(),
          throwsA(isA<CacheException>().having(
            (e) => e.message,
            'message',
            'No cached messages found',
          )));
    });
  });

  group('cacheMessage', () {
    final testTimestamp = DateTime.now();
    final testMessageModel = ChatMessageModel(
      content: 'Hello',
      isUser: true,
      timestamp: testTimestamp,
    );

    test('should call SharedPreferences to cache the message', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn('[]');
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      // act
      await dataSource.cacheMessage(testMessageModel);

      // assert
      final expectedJsonString = json.encode([testMessageModel.toJson()]);
      verify(mockSharedPreferences.setString(
        cachedMessagesKey,
        expectedJsonString,
      ));
    });

    test('should append new message to existing cached messages', () async {
      // arrange
      final existingMessage = ChatMessageModel(
        content: 'Previous message',
        isUser: false,
        timestamp: testTimestamp.subtract(const Duration(minutes: 1)),
      );
      when(mockSharedPreferences.getString(any))
          .thenReturn(json.encode([existingMessage.toJson()]));
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      // act
      await dataSource.cacheMessage(testMessageModel);

      // assert
      final expectedJsonString = json.encode([
        existingMessage.toJson(),
        testMessageModel.toJson(),
      ]);
      verify(mockSharedPreferences.setString(
        cachedMessagesKey,
        expectedJsonString,
      ));
    });
  });

  group('clearCachedMessages', () {
    test('should call SharedPreferences to clear the cached messages',
        () async {
      // arrange
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

      // act
      await dataSource.clearCachedMessages();

      // assert
      verify(mockSharedPreferences.remove(cachedMessagesKey));
    });

    test('should throw CacheException when clear operation fails', () async {
      // arrange
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => false);

      // act
      final call = dataSource.clearCachedMessages;

      // assert
      expect(
          () => call(),
          throwsA(isA<CacheException>().having(
            (e) => e.message,
            'message',
            'Failed to clear cache',
          )));
    });
  });
}
