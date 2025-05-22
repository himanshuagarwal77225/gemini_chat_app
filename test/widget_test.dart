// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';
import 'package:gemini_chat_app/core/error/failures.dart';
import 'package:gemini_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:gemini_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:gemini_chat_app/features/chat/domain/usecases/send_message.dart';
import 'package:gemini_chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:gemini_chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:gemini_chat_app/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:intl/intl.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([ChatRepository, SendMessage])
void main() {
  late MockChatRepository mockChatRepository;
  late MockSendMessage mockSendMessage;
  late ChatBloc chatBloc;
  final fixedTime = DateTime(2024, 1, 1, 12, 0);

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockSendMessage = MockSendMessage();
    chatBloc = ChatBloc(
      sendMessage: mockSendMessage,
      repository: mockChatRepository,
    );

    final getIt = GetIt.instance;
    if (!getIt.isRegistered<ChatBloc>()) {
      getIt.registerFactory<ChatBloc>(() => chatBloc);
    }
  });

  tearDown(() {
    chatBloc.close();
    GetIt.instance.reset();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<ChatBloc>(
        create: (_) => chatBloc,
        child: const ChatPage(),
      ),
    );
  }

  group('ChatPage Widget Tests', () {
    testWidgets('ChatPage shows initial empty state',
        (WidgetTester tester) async {
      // Arrange
      when(mockChatRepository.getChatHistory())
          .thenAnswer((_) async => const Right([]));

      // Build our app and trigger a frame
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Start a conversation'), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
    });

    testWidgets('ChatPage shows message input and send button',
        (WidgetTester tester) async {
      // Arrange
      when(mockChatRepository.getChatHistory())
          .thenAnswer((_) async => const Right([]));

      // Build our app and trigger a frame
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify UI elements
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(IconButton), findsWidgets);
      expect(find.text('AI Assistant'), findsOneWidget);
      expect(find.text('Online'), findsOneWidget);
    });

    testWidgets('ChatPage can send a message', (WidgetTester tester) async {
      // Arrange
      final aiResponse = ChatMessage(
        content: 'Hi there!',
        isUser: false,
        timestamp: fixedTime,
      );

      when(mockChatRepository.getChatHistory())
          .thenAnswer((_) async => const Right([]));
      when(mockSendMessage.execute('Hello'))
          .thenAnswer((_) async => Right(aiResponse));

      // Build our app and trigger a frame
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter text and wait for _isComposing to update
      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();

      // Verify the send button is enabled (green color)
      final sendButton = find.byKey(const Key('send_button'));
      expect(sendButton, findsOneWidget);

      // Tap send button
      await tester.tap(sendButton);

      // Wait for the message to be added to the chat
      await tester.pump(); // Process the tap
      await tester.pump(); // Update UI with user message

      // Verify user message appears
      expect(find.textContaining('Hello'), findsOneWidget);

      // Wait for AI response
      await tester.pump(); // Start loading state
      await tester.pump(); // Process AI response
      await tester.pumpAndSettle(); // Complete any animations

      // Verify both messages are visible
      expect(find.textContaining('Hello'), findsOneWidget);
      expect(find.textContaining('Hi there!'), findsOneWidget);

      // Verify the mock was called
      verify(mockSendMessage.execute('Hello')).called(1);
    });

    testWidgets('ChatPage shows error state', (WidgetTester tester) async {
      // Arrange
      when(mockChatRepository.getChatHistory()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server error')));

      // Build our app and trigger a frame
      await tester.pumpWidget(createTestWidget());

      // Wait for async operations
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Assert - look for error message in SnackBar or error widget
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Text && widget.data!.contains('Server error')),
          findsOneWidget);
    });

    testWidgets('ChatPage shows typing indicator when loading',
        (WidgetTester tester) async {
      // Arrange
      final completer = Completer<Either<Failure, ChatMessage>>();

      when(mockChatRepository.getChatHistory())
          .thenAnswer((_) async => const Right([]));
      when(mockSendMessage.execute('Hello'))
          .thenAnswer((_) async => completer.future);

      // Build our app
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Send a message to trigger loading state
      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.tap(find.byType(IconButton).first);

      // Wait for loading state
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify typing indicator appears during loading
      expect(find.byType(TypingIndicator), findsOneWidget);

      // Complete the future to clean up
      completer.complete(Right(ChatMessage(
        content: 'Response',
        isUser: false,
        timestamp: fixedTime,
      )));
      await tester.pumpAndSettle();
    });

    testWidgets('ChatPage shows timestamps for messages',
        (WidgetTester tester) async {
      // Arrange
      final testMessage = ChatMessage(
        content: 'Hello',
        isUser: true,
        timestamp: fixedTime,
      );

      when(mockChatRepository.getChatHistory())
          .thenAnswer((_) async => Right([testMessage]));

      // Build our app
      await tester.pumpWidget(createTestWidget());

      // Wait for async operations
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Verify message and timestamp are shown
      expect(find.textContaining('Hello'), findsOneWidget);
      expect(find.textContaining(DateFormat('HH:mm').format(fixedTime)),
          findsOneWidget);
    });

    testWidgets('ChatPage handles empty input correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockChatRepository.getChatHistory())
          .thenAnswer((_) async => const Right([]));

      // Build our app
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Try to send empty message
      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      // Find and tap send button
      await tester.tap(find.byType(IconButton).first);
      await tester.pump();

      // Verify no message was sent
      verifyNever(mockSendMessage.execute(any));
    });
  });
}
