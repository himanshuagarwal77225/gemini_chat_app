import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/chat_message_model.dart';

const cachedMessageKey = 'CACHED_MESSAGES';

/// Interface for local data operations related to chat.
abstract class ChatLocalDataSource {
  /// Gets the cached list of [ChatMessageModel].
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<ChatMessageModel>> getCachedMessages();

  /// Caches a new [ChatMessageModel].
  ///
  /// Throws [CacheException] if caching fails.
  Future<void> cacheMessage(ChatMessageModel message);

  /// Clears all cached messages.
  ///
  /// Throws [CacheException] if clearing fails.
  Future<void> clearCachedMessages();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final SharedPreferences sharedPreferences;

  ChatLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ChatMessageModel>> getCachedMessages() async {
    final jsonString = sharedPreferences.getString(cachedMessageKey);
    if (jsonString == null) {
      throw CacheException('No cached messages found');
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ChatMessageModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException('Failed to parse cached messages');
    }
  }

  @override
  Future<void> cacheMessage(ChatMessageModel message) async {
    List<ChatMessageModel> messages = [];
    try {
      final existingMessages = await getCachedMessages();
      messages = List.from(existingMessages);
    } catch (e) {
      // If no messages exist yet, we'll start with an empty list
    }

    messages.add(message);
    final jsonString = json.encode(messages.map((m) => m.toJson()).toList());

    if (!await sharedPreferences.setString(cachedMessageKey, jsonString)) {
      throw CacheException('Failed to cache message');
    }
  }

  @override
  Future<void> clearCachedMessages() async {
    if (!await sharedPreferences.remove(cachedMessageKey)) {
      throw CacheException('Failed to clear cache');
    }
  }
}
