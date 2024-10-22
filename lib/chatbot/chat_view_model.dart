import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_model.dart';
import 'generative_model_service.dart';

final chatProvider = StateNotifierProvider<ChatViewModel, List<ChatMessage>>((ref) {
  return ChatViewModel(ref);
});

class ChatViewModel extends StateNotifier<List<ChatMessage>> {
  final StateNotifierProviderRef _ref;

  ChatViewModel(this._ref) : super([]);

  void sendMessage(String message) async {
    state = [...state, ChatMessage(text: "You: $message", type: ChatMessageType.user)];

    final response = await _ref.read(generativeChatServiceProvider).sendMessage(message);
    state = [...state, ChatMessage(text: "AI: $response", type: ChatMessageType.bot)];
  }
}
