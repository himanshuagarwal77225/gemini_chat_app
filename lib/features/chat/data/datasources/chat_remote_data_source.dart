import 'dart:async';
import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/app_config.dart';
import '../../../../core/error/exceptions.dart' as exceptions;
import '../models/chat_message_model.dart';

/// Interface for remote data operations related to chat.
abstract class ChatRemoteDataSource {
  /// Gets an AI response from the Gemini API.
  ///
  /// Throws:
  /// - [exceptions.ServerException] if there's an error with the API.
  /// - [NetworkException] if there's no internet connection.
  Future<ChatMessageModel> getAIResponse(String message);

  /// Sends a message to the remote API and returns the response.
  ///
  /// Throws [exceptions.ServerException] if the server returns an error.
  Future<ChatMessageModel> sendMessage(String message);
}

/// Implementation of [ChatRemoteDataSource] using Google's Gemini AI.
///
/// This class handles the actual communication with the Gemini AI service,
/// including model initialization and error handling.
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  GenerativeModel? _model;
  ChatSession? _chatSession;
  String? _selectedModel;
  final http.Client _client;

  // List of models to try in order of preference
  static const List<String> _preferredModels = [
    'gemini-1.5-flash',
    'gemini-1.5-pro',
    'gemini-pro',
    'gemini-pro-latest',
  ];

  /// Creates a new [ChatRemoteDataSourceImpl] instance.
  ///
  /// Parameters:
  ///   - client: Optional HTTP client for making requests.
  ChatRemoteDataSourceImpl({
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<void> _fetchAvailableModels() async {
    try {
      final url =
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models');
      final response = await _client.get(
        url,
        headers: {'x-goog-api-key': AppConfig.geminiApiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['models'] != null) {
          final availableModels = <String>[];

          // First, collect all available model names
          for (var model in data['models']) {
            final modelName = model['name'].toString();
            availableModels.add(modelName);
          }

          // Then try to find a preferred model that's available
          for (var preferredModel in _preferredModels) {
            final fullModelName = 'models/$preferredModel';
            if (availableModels.any((m) => m.endsWith(preferredModel))) {
              _selectedModel = fullModelName;
              return;
            }
          }

          // If no preferred model is found, try to find any text-capable Gemini model
          for (var modelName in availableModels) {
            if (modelName.contains('gemini') &&
                !modelName.contains('vision') &&
                !modelName.contains('embedding')) {
              _selectedModel = modelName;
              return;
            }
          }
        }
      } else {
        throw exceptions.ServerException(
            message: 'Failed to fetch models: ${response.statusCode}');
      }
    } catch (e) {
      throw exceptions.ServerException(
          message: 'Error fetching models: ${e.toString()}');
    }
  }

  Future<void> _initializeModel() async {
    try {
      await _fetchAvailableModels();

      if (_selectedModel == null) {
        throw exceptions.ServerException(message: 'No suitable model found');
      }

      _model = GenerativeModel(
        model: _selectedModel!,
        apiKey: AppConfig.geminiApiKey,
      );

      _chatSession = _model!.startChat(
        generationConfig: GenerationConfig(
          temperature: AppConfig.temperature,
          maxOutputTokens: AppConfig.maxOutputTokens,
        ),
      );
    } catch (e) {
      if (e is exceptions.ServerException) {
        rethrow;
      }
      throw exceptions.ServerException(
          message: 'Failed to initialize model: ${e.toString()}');
    }
  }

  @override
  Future<ChatMessageModel> getAIResponse(String message) async {
    try {
      if (_model == null) {
        await _initializeModel();
      }

      // Try chat session first
      try {
        if (_chatSession != null) {
          final chatResponse =
              await _chatSession!.sendMessage(Content.text(message));
          if (chatResponse.text != null && chatResponse.text!.isNotEmpty) {
            return ChatMessageModel.ai(content: chatResponse.text!);
          }
        }
      } catch (chatError) {
        // Chat session failed, will try direct generation
      }

      // Fallback to direct generation
      final response = await _model!.generateContent([Content.text(message)]);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        throw exceptions.ServerException(
          message: 'Empty response from AI',
        );
      }

      return ChatMessageModel.ai(content: responseText);
    } on GenerativeAIException catch (e) {
      throw exceptions.ServerException(message: 'AI Error: ${e.message}');
    } catch (e) {
      if (e is exceptions.ServerException) {
        rethrow;
      }
      throw exceptions.ServerException(
          message: 'Failed to get AI response: ${e.toString()}');
    }
  }

  @override
  Future<ChatMessageModel> sendMessage(String message) async {
    try {
      if (_model == null) {
        await _initializeModel();
      }

      return await getAIResponse(message);
    } catch (e) {
      throw exceptions.ServerException(
        message: e is exceptions.ServerException
            ? e.message
            : 'Failed to send message to AI',
      );
    }
  }
}
