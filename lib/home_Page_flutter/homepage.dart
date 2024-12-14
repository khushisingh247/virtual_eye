import 'package:flutter/material.dart';
import 'package:login_page/chatbot/chat_home.dart';
import 'package:login_page/home_Page_flutter/home_screen_bottom.dart';
import 'package:login_page/home_Page_flutter/services_bottom.dart';
import 'package:login_page/login_signup/login_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:camera/camera.dart';
import '../object_detection/realtime_object_detection.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myIndex = 0;
  List<CameraDescription>? cameras;
  List<Widget> widgetList = [];
  stt.SpeechToText _speechToText = stt.SpeechToText();  // Single instance for SpeechToText
  final FlutterTts flutterTts = FlutterTts();
  bool _isListening = false;
  String _command = '';

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
    initializeCameras();
    _initSpeech();
  }

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    setState(() {
      widgetList = [
        HomeScreenBottom(cameras: cameras!, startListening: _startListening, stopListening: _stopListening),
        const ServicesBottom(),
        //const Community(),
      ];
    });
  }

  // Request microphone permission
  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  // Initialize speech recognition
  void _initSpeech() async {
    bool available = await _speechToText.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() {
        print("Speech recognition initialized successfully");
      });
    } else {
      print("Speech recognition is not available");
    }
  }

  void _startListening() async {
    await _speechToText.listen(onResult: (val) {
      setState(() {
        _command = val.recognizedWords.toLowerCase();
        print('Recognized command: $_command');
        _handleVoiceCommand(_command);
      });
    });
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Handle voice commands centrally
  void _handleVoiceCommand(String command) {
    if (command.contains('open services')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>ServicesBottom(),
        ),
      );
    }
    if (command.contains('open home')) {
      setState(() {
        myIndex = 0;  // Navigate to "Home"
      });
    } else if (command.contains('open music')) {
      _openYouTubeMusic(); // Navigate to "Community"
    } else if (command.contains('log out')) {
      _showLogoutConfirmationDialog();
    } else if (command.contains('open object detection')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RealTimeObjectDetection(cameras: cameras!),
        ),
      );
    } else if (command.contains('open map')) {
      MapUtils.openMap(25.31668000, 83.01041000);
    }
    else if (command.contains('open chatbot')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatHome(),
        ),
      );
    }
    else if (command.contains('logout')) {
      _showLogoutConfirmationDialog();
    }
  }

  Future<void> _openYouTubeMusic() async {
    final Uri url = Uri.parse('https://music.youtube.com/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _playListeningInstruction() async {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.speak("Listening...");
      await flutterTts.awaitSpeakCompletion(true);

      // Play "Bole" in Hindi
      await flutterTts.setLanguage("hi-IN");
      await flutterTts.speak("Bole");

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isListening) {
          _stopListening();
        } else {
          _playListeningInstruction();
          _startListening();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          children: widgetList.isEmpty
              ? [Center(child: CircularProgressIndicator())]
              : widgetList,
          index: myIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          backgroundColor: const Color(0xFF404165),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: myIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.call),
            //   label: 'Services',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.queue_music),
              label: 'Music',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Log Out',
            ),
          ],
        ),

      ),
    );
  }
}


