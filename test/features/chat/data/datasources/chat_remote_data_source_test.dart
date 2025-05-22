import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_chat_app/core/error/exceptions.dart';
import 'package:gemini_chat_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:gemini_chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_remote_data_source_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClientTest),
])
void main() {
  late ChatRemoteDataSourceImpl dataSource;
  late MockHttpClientTest mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClientTest();
    dataSource = ChatRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('sendMessage', () {
    const testMessage = 'Hello';
    final testTimestamp = DateTime.now();
    final testResponse = {
      'content': 'Hi there!',
      'isUser': false,
      'timestamp': testTimestamp.toIso8601String(),
    };

    test('should perform a POST request with the message', () async {
      // arrange
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(json.encode(testResponse), 200));

      // act
      await dataSource.sendMessage(testMessage);

      // assert
      verify(mockHttpClient.post(
        any,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': testMessage,
        }),
      ));
    });

    test('should return ChatMessageModel when the response is successful (200)',
        () async {
      // arrange
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(json.encode(testResponse), 200));

      // act
      final result = await dataSource.sendMessage(testMessage);

      // assert
      expect(result, isA<ChatMessageModel>());
      expect(result.content, equals(testResponse['content']));
      expect(result.isUser, equals(testResponse['isUser']));
      expect(result.timestamp.toIso8601String(),
          equals(testResponse['timestamp']));
    });

    test(
        'should throw a ServerException when the response is unsuccessful (404)',
        () async {
      // arrange
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final call = dataSource.sendMessage;

      // assert
      expect(
          () => call(testMessage),
          throwsA(isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Server responded with status code: 404',
          )));
    });

    test('should throw a ServerException when the response is not valid JSON',
        () async {
      // arrange
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Invalid JSON', 200));

      // act
      final call = dataSource.sendMessage;

      // assert
      expect(
          () => call(testMessage),
          throwsA(isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Failed to parse server response',
          )));
    });
  });
}
