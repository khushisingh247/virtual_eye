import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:speech_to_text/speech_to_text.dart'; // Full package name
import 'package:flutter_tts/flutter_tts.dart'; // Import Text-to-Speech package

class VoiceFingerprintAuth {
  final LocalAuthentication auth = LocalAuthentication();
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();

  bool isListening = false;

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void startListening(Function(String) onResult) async {
    bool available = await speechToText.initialize();
    if (available) {
      isListening = true;
      speechToText.listen(onResult: (result) {
        onResult(result.recognizedWords); // Get the recognized words as string
      });
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void stopListening() {
    speechToText.stop();
    isListening = false;
  }

  Future<bool> authenticate(BuildContext context) async {
    await speak("Apply your fingerprint to authenticate"); // Speak when starting authentication
    bool authenticated = false;
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        _showSnackBar(context, 'Biometric authentication not available.');
        return false;
      }

      authenticated = await auth.authenticate(
        localizedReason: 'Apply your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      _showSnackBar(context, 'Error: $e');
      return false;
    }

    if (authenticated) {
      return true; // Authentication successful
    } else {
      _showSnackBar(context, 'Authentication failed.');
      return false;
    }
  }

  // Helper method to show a SnackBar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Method to announce the initial prompt when the app starts
  Future<void> announceInitialPrompt() async {
    await speak("Click anywhere and say fingerprint for authentication");
    // Only start listening after the TTS is done

  }
}


