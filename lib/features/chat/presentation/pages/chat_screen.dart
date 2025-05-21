import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_input_widget.dart';
import '../widgets/chat_message_widget.dart';

/// The main chat screen of the application.
///
/// This screen displays the chat interface, including the message list,
/// input field, and handles the interaction between the user and the AI.
/// It uses BLoC pattern for state management and updates the UI based on
/// the current chat state.
class ChatScreen extends StatelessWidget {
  /// Creates a new [ChatScreen] instance.
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
        actions: [
          // Clear chat history button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<ChatBloc>().add(ClearChatHistoryEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          // Initial state - load chat history
          if (state is ChatInitial) {
            context.read<ChatBloc>().add(LoadChatHistoryEvent());
            return const Center(child: CircularProgressIndicator());
          }

          // Loading state
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (state is ChatError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Messages loaded state
          if (state is ChatMessagesLoaded) {
            return Column(
              children: [
                // Message list
                Expanded(
                  child: state.messages.isEmpty
                      // Empty state message
                      ? const Center(
                          child: Text(
                            'Start a conversation with Gemini!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      // Chat message list
                      : ListView.builder(
                          reverse: true,
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state
                                .messages[state.messages.length - 1 - index];
                            return ChatMessageWidget(message: message);
                          },
                        ),
                ),
                // AI typing indicator
                if (state.isTyping)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                // Message input field
                const ChatInputWidget(),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
