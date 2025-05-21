import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/chat_message_model.dart';

/// Abstract class defining the contract for remote chat operations.
///
/// This interface defines how the application communicates with external
/// AI services (in this case, Google's Gemini AI).
abstract class ChatRemoteDataSource {
  /// Sends a message to the remote AI service.
  ///
  /// Parameters:
  ///   - message: The text message to send to the AI.
  ///
  /// Returns:
  ///   A [Future] that completes with a [ChatMessageModel] containing the AI's response.
  ///
  /// Throws:
  ///   - [Exception] if the AI service returns an error or empty response.
  Future<ChatMessageModel> sendMessage(String message);
}

/// Implementation of [ChatRemoteDataSource] using Google's Gemini AI.
///
/// This class handles the actual communication with the Gemini AI service,
/// including model initialization and error handling.
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  /// The Gemini AI model instance used for generating responses.
  final GenerativeModel _model;

  /// Creates a new [ChatRemoteDataSourceImpl] instance.
  ///
  /// Parameters:
  ///   - apiKey: The API key for authenticating with Gemini AI service.
  ChatRemoteDataSourceImpl({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-1.0-pro', // Updated model name
          apiKey: apiKey,
        );

  @override
  Future<ChatMessageModel> sendMessage(String message) async {
    try {
      // Create content for the AI model
      final content = [Content.text(message)];

      // Generate response from AI
      final response = await _model.generateContent(content);

      // Validate response
      if (response.text == null) {
        throw Exception('Empty response from AI');
      }

      // Convert AI response to chat message
      return ChatMessageModel.ai(content: response.text!);
    } catch (e) {
      throw Exception('Failed to get AI response: ${e.toString()}');
    }
  }
}
