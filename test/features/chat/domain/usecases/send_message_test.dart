import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_chat_app/core/error/failures.dart';
import 'package:gemini_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:gemini_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:gemini_chat_app/features/chat/domain/usecases/send_message.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'send_message_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late SendMessage usecase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    usecase = SendMessage(mockRepository);
  });

  final testMessage = ChatMessage(
    content: 'Hello',
    isUser: false,
    timestamp: DateTime.now(),
  );

  test('should send message through the repository', () async {
    // arrange
    when(mockRepository.sendMessage('Hello'))
        .thenAnswer((_) async => Right(testMessage));

    // act
    final result = await usecase('Hello');

    // assert
    expect(result, Right(testMessage));
    verify(mockRepository.sendMessage('Hello'));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(mockRepository.sendMessage('Hello')).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Server error')));

    // act
    final result = await usecase('Hello');

    // assert
    expect(result, const Left(ServerFailure(message: 'Server error')));
    verify(mockRepository.sendMessage('Hello'));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should not send empty message', () async {
    // act
    final result = await usecase('');

    // assert
    expect(result,
        const Left(ValidationFailure(message: 'Message cannot be empty')));
    verifyNever(mockRepository.sendMessage(any));
  });

  test('should not send whitespace-only message', () async {
    // act
    final result = await usecase('   ');

    // assert
    expect(result,
        const Left(ValidationFailure(message: 'Message cannot be empty')));
    verifyNever(mockRepository.sendMessage(any));
  });
}
