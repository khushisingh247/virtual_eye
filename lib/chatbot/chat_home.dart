import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'colors.dart';
import 'chat_model.dart';
import 'chat_view_model.dart';

class ChatHome extends ConsumerStatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends ConsumerState<ChatHome> {
  var text = "I am a smart assistant chatbot";
  SpeechToText speechToText = SpeechToText();
  FlutterTts flutterTts = FlutterTts(); // Text-to-Speech instance
  var isListening = false;

  final ScrollController scrollController = ScrollController();
  List<String> spokenMessages = []; // Track messages that have been spoken

  @override
  void initState() {
    super.initState();
    _playOpeningInstruction(); // Play the instruction when app opens

    // Initialize TTS
    flutterTts.setCompletionHandler(() {
      // Handle actions after TTS completes if needed
    });
  }

  // Method to play the opening instruction in both English and Hindi
  Future<void> _playOpeningInstruction() async {
    // Play the English instruction
    await flutterTts.setLanguage("en-IN");
    await Future.delayed(Duration(milliseconds: 250));
    await flutterTts.speak("Hold the screen to ask a question.");

    // Wait for the English instruction to finish before speaking in Hindi
    await flutterTts.awaitSpeakCompletion(true);

    // Play the Hindi instruction
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.speak("Screen ko dabaen rakhe aur prashn karen.");
  }



  // Method to provide auditory feedback when recording starts
  Future<void> _playStartRecordingSound() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.speak("Listening...");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.speak("Bole");
  }

  // Method to provide auditory feedback when recording stops
  Future<void> _playStopRecordingSound() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.speak("Recording stopped.");
  }

  // Scroll to the latest message
  void scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  // Method to convert text to speech
  Future<void> _speak(String message, ChatMessageType type) async {
    await _setTtsLanguage(type); // Set language before speaking
    await flutterTts.speak(message);
  }

  // Method to stop any ongoing speech (TTS)
  Future<void> _stopSpeech() async {
    await flutterTts.stop(); // This stops any speech that's currently happening
  }

  // Method to set the TTS language based on the chat type
  Future<void> _setTtsLanguage(ChatMessageType type) async {
    if (type == ChatMessageType.bot) {
      // Assuming bot messages are in Hindi
      await flutterTts.setLanguage("hi-IN");
    } else {
      // Assuming other messages are in English
      await flutterTts.setLanguage("en-IN");
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(Icons.sort_rounded, color: Colors.white),
        backgroundColor: bgColor,
        elevation: 0.0,
        title: const Text(
          "Voice Assistant Chatbot",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: GestureDetector(
        onTapDown: (details) async {
          // Stop TTS before starting to listen
          await _stopSpeech();

          // Play sound when recording starts
          await _playStartRecordingSound();

          if (!isListening) {
            var available = await speechToText.initialize();
            if (available) {
              setState(() {
                isListening = true;
                speechToText.listen(
                  onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  },
                );
              });
            }
          }
        },
        onTapUp: (details) async {
          setState(() {
            isListening = false;
          });
          speechToText.stop();

          // Play sound when recording stops
          await _playStopRecordingSound();

          // Send the new message recognized by speech
          ref.read(chatProvider.notifier).sendMessage(text);
          scrollMethod();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 21,
                  color: isListening ? Colors.black54 : Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: chatBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: chatMessages.length,
                    itemBuilder: (BuildContext context, int index) {
                      var chat = chatMessages[index];

                      // Speak the chatbot response only if it's a bot message and hasn't been spoken yet
                      if (chat.type == ChatMessageType.bot && !spokenMessages.contains(chat.text)) {
                        // Call a method to speak the message asynchronously
                        _speak(chat.text, chat.type); // Call text-to-speech for the response
                        spokenMessages.add(chat.text);  // Mark the message as spoken
                      }

                      return chatBubble(chatText: chat.text, type: chat.type);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "AI Chatbot",
                style: TextStyle(
                    fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBubble({required String chatText, required ChatMessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: bgColor1,
          child: Icon(Icons.person, color: Colors.black),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Text(
              "$chatText",
              style: const TextStyle(
                color: chatBgColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

