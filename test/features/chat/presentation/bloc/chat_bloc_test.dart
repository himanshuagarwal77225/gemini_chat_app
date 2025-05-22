import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:gemini_chat_app/core/error/failures.dart';
import 'package:gemini_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:gemini_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:gemini_chat_app/features/chat/domain/usecases/send_message.dart';
import 'package:gemini_chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:gemini_chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:gemini_chat_app/features/chat/presentation/bloc/chat_state.dart';

import 'chat_bloc_test.mocks.dart';

@GenerateMocks([ChatRepository, SendMessage])
void main() {
  late ChatBloc bloc;
  late MockChatRepository mockRepository;
  late MockSendMessage mockSendMessage;
  final fixedTime = DateTime(2024, 1, 1, 12, 0);

  setUp(() {
    mockRepository = MockChatRepository();
    mockSendMessage = MockSendMessage();
    bloc = ChatBloc(
      sendMessage: mockSendMessage,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be ChatInitial', () {
    expect(bloc.state, isA<ChatInitial>());
    expect(bloc.state.messages, isEmpty);
  });

  group('LoadChatHistoryEvent', () {
    final testMessages = [
      ChatMessage(
        content: 'Hello',
        isUser: true,
        timestamp: fixedTime,
      ),
      ChatMessage(
        content: 'Hi there!',
        isUser: false,
        timestamp: fixedTime,
      ),
    ];

    test(
        'should emit [ChatLoading, ChatInitial] when history is loaded successfully',
        () async {
      // arrange
      when(mockRepository.getChatHistory())
          .thenAnswer((_) async => Right(testMessages));

      // assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          const ChatLoading([]),
          ChatInitial(testMessages),
        ]),
      );

      // act
      bloc.add(const LoadChatHistoryEvent());
    });

    test('should emit [ChatLoading, ChatError] when loading fails', () async {
      // arrange
      when(mockRepository.getChatHistory()).thenAnswer((_) async =>
          const Left(ServerFailure(message: 'Failed to load chat history')));

      // assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          const ChatLoading([]),
          const ChatError([], 'Failed to load chat history'),
        ]),
      );

      // act
      bloc.add(const LoadChatHistoryEvent());
    });
  });

  group('SendMessageEvent', () {
    final userMessage = ChatMessage(
      content: 'Hello',
      isUser: true,
      timestamp: fixedTime,
    );

    final aiResponse = ChatMessage(
      content: 'Hi there!',
      isUser: false,
      timestamp: fixedTime,
    );

    test('should emit correct states when message is sent successfully',
        () async {
      // arrange
      when(mockSendMessage.execute('Hello'))
          .thenAnswer((_) async => Right(aiResponse));

      final expectedStates = [
        isA<ChatMessageSent>().having(
          (state) => state.messages.length,
          'messages length',
          1,
        ),
        isA<ChatLoading>().having(
          (state) => state.messages.length,
          'messages length',
          1,
        ),
        isA<ChatMessageSent>().having(
          (state) => state.messages.length,
          'messages length',
          2,
        ),
      ];

      // assert
      expectLater(bloc.stream, emitsInOrder(expectedStates));

      // act
      bloc.add(const SendMessageEvent('Hello'));
    });

    test('should emit correct states when sending fails', () async {
      // arrange
      when(mockSendMessage.execute('Hello')).thenAnswer((_) async =>
          const Left(ServerFailure(message: 'Failed to send message')));

      // assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ChatMessageSent>()
              .having((state) => state.messages.length, 'messages length', 1),
          isA<ChatLoading>()
              .having((state) => state.messages.length, 'messages length', 1),
          isA<ChatError>()
              .having((state) => state.messages.length, 'messages length', 1)
              .having((state) => (state as ChatError).error, 'error message',
                  'Failed to send message'),
        ]),
      );

      // act
      bloc.add(const SendMessageEvent('Hello'));
    });
  });

  group('ClearHistoryEvent', () {
    test(
        'should emit [ChatLoading, ChatInitial] when history is cleared successfully',
        () async {
      // arrange
      when(mockRepository.clearHistory())
          .thenAnswer((_) async => const Right(null));

      // assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          const ChatLoading([]),
          const ChatInitial([]),
        ]),
      );

      // act
      bloc.add(const ClearHistoryEvent());
    });

    test('should emit [ChatLoading, ChatError] when clearing fails', () async {
      // arrange
      when(mockRepository.clearHistory()).thenAnswer((_) async =>
          const Left(ServerFailure(message: 'Failed to clear history')));

      // assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          const ChatLoading([]),
          const ChatError([], 'Failed to clear history'),
        ]),
      );

      // act
      bloc.add(const ClearHistoryEvent());
    });
  });
}
