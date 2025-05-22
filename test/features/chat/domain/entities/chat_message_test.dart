import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_chat_app/features/chat/domain/entities/chat_message.dart';

void main() {
  group('ChatMessage', () {
    test('should create ChatMessage with all properties', () {
      // Arrange
      final timestamp = DateTime.now();

      // Act
      final message = ChatMessage(
        content: 'Hello',
        isUser: true,
        timestamp: timestamp,
      );

      // Assert
      expect(message.content, 'Hello');
      expect(message.isUser, true);
      expect(message.timestamp, timestamp);
    });

    test('should be equal when all properties are the same', () {
      // Arrange
      final timestamp = DateTime.now();
      final message1 = ChatMessage(
        content: 'Hello',
        isUser: true,
        timestamp: timestamp,
      );
      final message2 = ChatMessage(
        content: 'Hello',
        isUser: true,
        timestamp: timestamp,
      );

      // Assert
      expect(message1, message2);
    });

    test('should not be equal when properties are different', () {
      // Arrange
      final timestamp = DateTime.now();
      final message1 = ChatMessage(
        content: 'Hello',
        isUser: true,
        timestamp: timestamp,
      );
      final message2 = ChatMessage(
        content: 'Different',
        isUser: true,
        timestamp: timestamp,
      );

      // Assert
      expect(message1, isNot(message2));
    });

    group('ChatMessage.user factory', () {
      test('should create user message with current timestamp', () {
        // Act
        final message = ChatMessage.user(content: 'Hello');

        // Assert
        expect(message.content, 'Hello');
        expect(message.isUser, true);
        expect(message.timestamp.difference(DateTime.now()).inSeconds, 0);
      });
    });

    group('ChatMessage.ai factory', () {
      test('should create AI message with current timestamp', () {
        // Act
        final message = ChatMessage.ai(content: 'Hello');

        // Assert
        expect(message.content, 'Hello');
        expect(message.isUser, false);
        expect(message.timestamp.difference(DateTime.now()).inSeconds, 0);
      });
    });
  });
}
