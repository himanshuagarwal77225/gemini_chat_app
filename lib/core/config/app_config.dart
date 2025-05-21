/// Configuration class for managing application-wide settings and API keys.
///
/// This class provides static access to configuration values used throughout
/// the application, such as API keys and environment-specific settings.
class AppConfig {
  /// Returns the Gemini API key from environment variables or fallback value.
  ///
  /// The method first attempts to retrieve the API key from dart-define parameters.
  /// If not found, falls back to a hardcoded value (not recommended for production).
  ///
  /// Returns:
  ///   A [String] containing the Gemini API key.
  static String get geminiApiKey {
    // First try to get from dart-define
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isNotEmpty) {
      return apiKey;
    }

    // Fallback to hardcoded key (NOT RECOMMENDED for production)
    // Replace this with your API key for testing
    return 'YOUR_API_KEY_HERE';
  }
}
