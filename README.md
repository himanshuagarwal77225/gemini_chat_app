# Gemini Chat App

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

## Prerequisites

Before running the application, make sure you have:

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- A Google Cloud account with Gemini API access
- Your Gemini API key

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/himanshuagarwal77225/gemini_chat_app.git
cd gemini_chat_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Set up your Gemini API key:
    - Create a `.env` file in the project root
    - Add your API key:
      ```
      GEMINI_API_KEY=your_api_key_here
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
│   ├── error/
│   ├── network/
│   └── utils/
├── features/
│   └── chat/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

### Key Components

- **Data Layer**: Handles data operations and external APIs
- **Domain Layer**: Contains business logic and entities
- **Presentation Layer**: Manages UI and state
    - BLoC pattern for state management
    - Widgets for UI components

## Dependencies

- `flutter_bloc`: State management
- `go_router`: Navigation
- `google_generative_ai`: Gemini AI API integration
- `equatable`: Value equality
- `shared_preferences`: Local storage
- `intl`: Internationalization

## Architecture

The app implements clean architecture with three main layers:

1. **Presentation Layer**
    - ChatScreen
    - ChatBloc
    - UI Widgets

2. **Domain Layer**
    - Entities
    - Repositories
    - Use Cases

3. **Data Layer**
    - Repository Implementations
    - Data Sources
    - Models

## State Management

The app uses the BLoC pattern for state management with the following components:

- **Events**
    - SendMessageEvent
    - LoadChatHistoryEvent
    - ClearChatHistoryEvent

- **States**
    - ChatInitial
    - ChatLoading
    - ChatError
    - ChatMessagesLoaded

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