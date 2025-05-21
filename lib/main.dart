import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/pages/chat_screen.dart';
import 'injection_container.dart' as di;

/// Entry point of the application.
///
/// Initializes dependencies and runs the app with proper configuration.
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Run the app
  runApp(const MyApp());
}

/// Root widget of the application.
///
/// This widget sets up the app's routing, theme, and global configuration.
/// It uses GoRouter for navigation and provides the ChatBloc to the widget tree.
class MyApp extends StatelessWidget {
  /// Creates a new [MyApp] instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configure app routes
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
            create: (_) => di.sl<ChatBloc>(),
            child: const ChatScreen(),
          ),
        ),
      ],
    );

    // Return the configured app
    return MaterialApp.router(
      title: 'Gemini Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
