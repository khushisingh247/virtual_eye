import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:login_page/home_Page_flutter/HomeButton.dart';
import 'package:login_page/object_detection/realtime_object_detection.dart';
import 'package:url_launcher/url_launcher.dart';

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

class HomeScreenBottom extends StatelessWidget {
  final List<CameraDescription>? cameras;
  final VoidCallback startListening;
  final VoidCallback stopListening;

  const HomeScreenBottom({
    Key? key,
    required this.cameras,
    required this.startListening,
    required this.stopListening,
  }) : super(key: key);

  Future<void> _openGoogleVoiceSearch() async {
    const String url = 'https://www.google.com/voice';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameras == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onTap: () {
        // When user taps anywhere on the screen, start or stop listening
        stopListening();
        startListening();
      },
      child: Scaffold(
        backgroundColor: Colors.white38,
        body: SingleChildScrollView(
          // This makes the page scrollable
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
                            color: Colors.white, // Text color
                            fontSize: 16, // Text size
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RealTimeObjectDetection(cameras: cameras!),
                                        ),
                                      );
                                    },
                                  ),
                                  CatigoryW(
                                    image: 'images/map-locator.png',
                                    text: ' Map',
                                    color: Colors.white,
                                    onPressed: () async {
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
                                    onPressed: _openGoogleVoiceSearch,
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

