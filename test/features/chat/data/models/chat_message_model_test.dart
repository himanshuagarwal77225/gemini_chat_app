import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:gemini_chat_app/features/chat/domain/entities/chat_message.dart';

void main() {
  final testTimestamp = DateTime.now();
  final testChatMessageModel = ChatMessageModel(
    content: 'Hello',
    isUser: true,
    timestamp: testTimestamp,
  );

  test('should be a subclass of ChatMessage entity', () {
    // assert
    expect(testChatMessageModel, isA<ChatMessage>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON contains proper data', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'content': 'Hello',
        'isUser': true,
        'timestamp': testTimestamp.toIso8601String(),
      };

      // act
      final result = ChatMessageModel.fromJson(jsonMap);

      // assert
      expect(result, equals(testChatMessageModel));
    });

    test('should handle missing timestamp by using current time', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'content': 'Hello',
        'isUser': true,
      };

      // act
      final result = ChatMessageModel.fromJson(jsonMap);

      // assert
      expect(result.content, equals('Hello'));
      expect(result.isUser, equals(true));
      expect(result.timestamp, isA<DateTime>());
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      // act
      final result = testChatMessageModel.toJson();

      // assert
      final expectedMap = {
        'content': 'Hello',
        'isUser': true,
        'timestamp': testTimestamp.toIso8601String(),
      };
      expect(result, equals(expectedMap));
    });
  });

  group('JSON encoding/decoding', () {
    test('should correctly encode and decode a ChatMessageModel', () {
      // act
      final jsonString = json.encode(testChatMessageModel.toJson());
      final decodedModel = ChatMessageModel.fromJson(json.decode(jsonString));

      // assert
      expect(decodedModel, equals(testChatMessageModel));
    });

    test('should correctly encode and decode a list of ChatMessageModels', () {
      // arrange
      final testModels = [
        testChatMessageModel,
        ChatMessageModel(
          content: 'Hi there!',
          isUser: false,
          timestamp: testTimestamp.add(const Duration(minutes: 1)),
        ),
      ];

      // act
      final jsonString =
          json.encode(testModels.map((m) => m.toJson()).toList());
      final decodedModels = (json.decode(jsonString) as List)
          .map((item) => ChatMessageModel.fromJson(item))
          .toList();

      // assert
      expect(decodedModels, equals(testModels));
    });
  });

  group('equality', () {
    test('should be equal when all properties match', () {
      // arrange
      final copy = ChatMessageModel(
        content: testChatMessageModel.content,
        isUser: testChatMessageModel.isUser,
        timestamp: testChatMessageModel.timestamp,
      );

      // assert
      expect(copy, equals(testChatMessageModel));
      expect(copy.hashCode, equals(testChatMessageModel.hashCode));
    });

    test('should not be equal when properties differ', () {
      // arrange
      final different = ChatMessageModel(
        content: 'Different content',
        isUser: testChatMessageModel.isUser,
        timestamp: testChatMessageModel.timestamp,
      );

      // assert
      expect(different, isNot(equals(testChatMessageModel)));
      expect(different.hashCode, isNot(equals(testChatMessageModel.hashCode)));
    });
  });

  group('factory constructors', () {
    test('user constructor should create a user message', () {
      // Act
      final message = ChatMessageModel.user(content: 'Hello');

      // Assert
      expect(message.content, 'Hello');
      expect(message.isUser, true);
      expect(message.timestamp.difference(DateTime.now()).inSeconds, 0);
    });

    test('ai constructor should create an AI message', () {
      // Act
      final message = ChatMessageModel.ai(content: 'Hello');

      // Assert
      expect(message.content, 'Hello');
      expect(message.isUser, false);
      expect(message.timestamp.difference(DateTime.now()).inSeconds, 0);
    });

    test('fromEntity should create a model from a ChatMessage entity', () {
      // Arrange
      final entity = ChatMessage(
        content: 'Test message',
        isUser: true,
        timestamp: testTimestamp,
      );

      // Act
      final model = ChatMessageModel.fromEntity(entity);

      // Assert
      expect(model, isA<ChatMessageModel>());
      expect(model.content, entity.content);
      expect(model.isUser, entity.isUser);
      expect(model.timestamp, entity.timestamp);
    });
  });
}
