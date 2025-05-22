# Gemini Chat

A modern Flutter chat application powered by Google's Gemini AI API. This project demonstrates the
implementation of a chatbot using clean architecture principles and best practices.

## Features

- 🤖 Integration with Google's Gemini AI API
- 💬 Real-time chat interface
- 🎨 Material Design 3 theming
- 📱 Responsive UI with message bubbles and avatars
- 💾 Local chat history persistence
- ⚡ Efficient state management with BLoC pattern
- 🧹 Clean Architecture implementation
- 🖥️ Cross-platform support (Windows, macOS, Linux, Web)

## Demo

Watch the app in action:

https://github.com/himanshuagarwal77225/ai_chatbot/blob/master/demo.mp4

Key highlights in the demo:

- 🚀 Smooth chat interactions
- 🎯 Real-time AI responses
- 🎨 Clean and intuitive UI
- 💫 Fluid animations
- 🔄 Chat history management

## Prerequisites

Before running the application, make sure you have:

- Flutter SDK (latest stable version)
- Dart SDK (>=3.2.3 <4.0.0)
- A Google Cloud account with Gemini API access
- Your Gemini API key

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/himanshuagarwal77225/ai_chatbot.git
cd ai_chatbot
```

2. Install dependencies:

```bash
flutter pub get
```

3. Set up your Gemini API key in `lib/core/config/app_config.dart`:
   ```dart
   static const String geminiApiKey = 'your_api_key_here';
   ```

4. Run the app:

```bash
flutter run
```

## Project Structure

The project follows clean architecture principles with the following structure:

```
lib/
├── core/
│   ├── config/      # App configuration
│   ├── error/       # Error handling
│   └── network/     # Network utilities
├── features/
│   └── chat/
│       ├── data/           # Data layer
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/         # Domain layer
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/   # Presentation layer
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── main.dart
```

## Dependencies

Key dependencies include:

- `flutter_bloc`: ^9.1.1 - State management
- `google_generative_ai`: ^0.4.7 - Gemini AI API integration
- `get_it`: ^8.0.3 - Dependency injection
- `equatable`: ^2.0.7 - Value equality
- `shared_preferences`: ^2.5.3 - Local storage
- `internet_connection_checker`: ^3.0.1 - Network connectivity
- `window_size` - Desktop window management
- `intl`: ^0.20.2 - Internationalization

Development dependencies:

- `mockito`: ^5.4.4 - Mocking for tests
- `build_runner`: ^2.4.8 - Code generation
- `flutter_lints`: ^2.0.0 - Linting rules

## Architecture

The app implements clean architecture with three main layers:

1. **Presentation Layer**
    - Chat Page
    - Chat BLoC
    - UI Widgets (Messages, Input, Typing Indicator)

2. **Domain Layer**
    - Chat Message Entity
    - Chat Repository Interface
    - Use Cases (Send Message, Get History)

3. **Data Layer**
    - Repository Implementation
    - Remote Data Source (Gemini AI)
    - Local Data Source (SharedPreferences)

## State Management

The app uses the BLoC pattern with the following components:

- **Events**
    - SendMessageEvent
    - LoadChatHistoryEvent
  - ClearHistoryEvent

- **States**
    - ChatInitial
    - ChatLoading
    - ChatError
  - ChatSuccess

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Google's Gemini AI team for providing the API
- Flutter team for the amazing framework
- The open-source community for inspiration and support 