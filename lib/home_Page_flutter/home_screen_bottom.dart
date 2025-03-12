import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:login_page/chatbot/chat_home.dart';
import 'package:login_page/home_Page_flutter/HomeButton.dart';
import 'package:login_page/home_Page_flutter/services_bottom.dart';
import 'package:login_page/object_detection/realtime_object_detection.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';

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

class HomeScreenBottom extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final VoidCallback startListening;
  final VoidCallback stopListening;

  const HomeScreenBottom({
    Key? key,
    required this.cameras,
    required this.startListening,
    required this.stopListening,
  }) : super(key: key);

  @override
  _HomeScreenBottomState createState() => _HomeScreenBottomState();
}

class _HomeScreenBottomState extends State<HomeScreenBottom> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _playWelcomeMessage();
  }

  Future<void> _playWelcomeMessage() async {
    try {
      await _flutterTts.stop(); // Stop any ongoing speech before starting
      await _flutterTts.setLanguage("en-IN");
      await _flutterTts.speak("Welcome to our app. Tap anywhere to give a command. You have to say 'open' before the option of object detection, chatbot, map, services, music, logout. Example: open chatbot.");
      await _flutterTts.awaitSpeakCompletion(true);

      await _flutterTts.setLanguage("hi-IN");
      await _flutterTts.speak("Hamare app mein aapka swagat hai. Command dene ke liye kahin bhi click karein. Aapko object detection, chatbot, map, services, music, aur logout jaise vikalpo ke istemal karne ke liye pehle 'open' bolein. Jaise ki 'open chatbot'.");
      await _flutterTts.awaitSpeakCompletion(true);
    } catch (e) {
      print("Error playing welcome message: $e");
    }
  }

  // Future<void> _playWelcomeMessage() async {
  //   try {
  //     await _flutterTts.setLanguage("en-IN");
  //     await _flutterTts.speak("Welcome to our app. Tap anywhere to give a command. You have to say 'open' before the option of object detection, chatbot, map, services, music, logout. example open chatbot.");
  //     await _flutterTts.awaitSpeakCompletion(true);
  //     await _flutterTts.setLanguage("hi-IN");
  //     await _flutterTts.speak(" Hamare app mein aapka swagat hai.Command dene ke liye kahin bhi click karein. Aapko object detection, chatbot, map, services, music, aur logout jaise vikalpo ke istemal karne ke liye pehle 'open' bole . jaise ki ' open chatbot'");
  //   } catch (e) {
  //     print("Error playing welcome message: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        widget.stopListening();
        widget.startListening();
      },
      child: Scaffold(
        backgroundColor: Colors.white38,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Transform.rotate(
                    origin: const Offset(30, -60),
                    angle: 2.4,
                    child: Container(
                      margin: const EdgeInsets.only(left: 75, top: 40),
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          colors: [
                            Color(0xffFD8BAB),
                            Color(0xFF28265B),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Virtual Eye',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Click anywhere to give user Command like "open object detection","open map"',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CatigoryW(
                                    image: 'images/object.jpg',
                                    text: 'Object Detection',
                                    color: Colors.white,
                                    onDoubleTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RealTimeObjectDetection(cameras: widget.cameras!),
                                        ),
                                      );
                                    },
                                  ),
                                  CatigoryW(
                                    image: 'images/map-locator.png',
                                    text: ' Map',
                                    color: Colors.white,
                                    onDoubleTap: () async {
                                      await MapUtils.openMap(25.31668000, 83.01041000);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CatigoryW(
                                    image: 'images/chatbot.png',
                                    text: 'Chatbot',
                                    color: Colors.white,
                                    onDoubleTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatHome(),
                                        ),
                                      );
                                    },
                                  ),
                                  CatigoryW(
                                    image: 'images/call_1.png',
                                    text: 'Services',
                                    color: Colors.white,
                                    onDoubleTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>ServicesBottom(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
