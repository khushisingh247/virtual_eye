import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:login_page/home_Page_flutter/HomeButton.dart';
import 'package:login_page/object_detection/realtime_object_detection.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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

class HomeScreenBottom extends StatefulWidget {
  const HomeScreenBottom({super.key, required cameras});

  @override
  State<HomeScreenBottom> createState() => _HomeScreenBottomState();
}

class _HomeScreenBottomState extends State<HomeScreenBottom> {
  List<CameraDescription>? cameras;
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _command = '';

  @override
  void initState() {
    super.initState();
    initializeCameras();
    _initSpeech();
  }

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    setState(() {});
  }

  // Initialize speech recognition
  void _initSpeech() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {});  // Update state when speech recognition is ready
    }
  }

  // Start listening for voice commands
  void _startListening() async {
    await _speechToText.listen(onResult: (val) {
      setState(() {
        _command = val.recognizedWords.toLowerCase();
        _handleVoiceCommand(_command);
      });
    });
    setState(() {
      _isListening = true;
    });
  }

  // Stop listening
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Handle voice commands
  void _handleVoiceCommand(String command) {
    if (command.contains('open object detection')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RealTimeObjectDetection(cameras: cameras!),
        ),
      );
    } else if (command.contains('open map')) {
      MapUtils.openMap(25.31668000, 83.01041000);
    } else if (command.contains('open chatbot')) {
      _openGoogleVoiceSearch();
    }
  }

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
      return Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onTap: () {
        // When user taps anywhere on the screen, start or stop listening
        if (_isListening) {
          _stopListening();
        } else {
          _startListening();
        }
      },
      child: Scaffold(
        backgroundColor:Colors.purple,
        //backgroundColor: Color(0xFF393767),
        body: SingleChildScrollView(
          // This makes the page scrollable
          child: Column(
            children: [
              Stack(
                children: [
                  Transform.rotate(
                    origin: Offset(30, -60),
                    angle: 2.4,
                    child: Container(
                      margin: EdgeInsets.only(left: 75, top: 40),
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          colors: [ Color(0xffFD8BAB),Color(0xFFFD4497)],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 70),
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
                          'A Supporting App For Blind Person',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),


                        Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CatigoryW(
                                    image: 'images/object.jpg',
                                    text: 'Object Detection',
                                    color: const Color(0xFF0C77C0),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RealTimeObjectDetection(
                                                  cameras: cameras!),
                                        ),
                                      );
                                    },
                                  ),
                                  CatigoryW(
                                    image: 'images/map-locator.png',
                                    text: ' Map',
                                    color: const Color(0xFFFD8C44),
                                    onPressed: () async {
                                      await MapUtils.openMap(
                                          25.31668000, 83.01041000);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  CatigoryW(
                                    image: 'images/chatbot.png',
                                    text: 'Chatbot',
                                    color: Color(0xFF47B4FF),
                                    onPressed: _openGoogleVoiceSearch,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),  // Adding some space between the text and the box
                          padding: EdgeInsets.all(15),  // Padding inside the box
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),  // 20% opacity for transparency
                            borderRadius: BorderRadius.circular(10),  // Rounded corners for the box
                            boxShadow:const [
                              BoxShadow(
                                color: Colors.black26,  // Shadow color
                                blurRadius: 6,  // Softness of the shadow
                                offset: Offset(0, 2),  // Position of the shadow
                              ),
                            ],
                          ),
                          child: const Text(
                            'Click anywhere to give user Command like "open object detection","open map","open chatbot"',
                            style: TextStyle(
                              color: Colors.white,  // Text color
                              fontSize: 16,  // Text size
                            ),
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


// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:login_page/home_Page_flutter/HomeButton.dart';
// import 'package:login_page/object_detection/realtime_object_detection.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:url_launcher/url_launcher.dart';
//
// class MapUtils {
//   MapUtils._();
//
//   static Future<void> openMap(double latitude, double longitude) async {
//     String googleUrl =
//         'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//     if (await canLaunchUrl(Uri.parse(googleUrl))) {
//       await launchUrl(Uri.parse(googleUrl));
//     } else {
//       throw 'Could not open the map.';
//     }
//   }
// }
//
// class HomeScreenBottom extends StatefulWidget {
//   const HomeScreenBottom({super.key, required cameras});
//
//   @override
//   State<HomeScreenBottom> createState() => _HomeScreenBottomState();
// }
//
// class _HomeScreenBottomState extends State<HomeScreenBottom> {
//   List<CameraDescription>? cameras;
//   stt.SpeechToText _speechToText = stt.SpeechToText();
//   bool _isListening = false;
//   String _command = '';
//
//   @override
//   void initState() {
//     super.initState();
//     initializeCameras();
//     _initSpeech();
//   }
//
//   Future<void> initializeCameras() async {
//     cameras = await availableCameras();
//     setState(() {});
//   }
//
//   // Initialize speech recognition
//   void _initSpeech() async {
//     bool available = await _speechToText.initialize();
//     if (available) {
//       setState(() {});
//     }
//   }
//
//   // Start listening for voice commands
//   void _startListening() async {
//     await _speechToText.listen(onResult: (val) {
//       setState(() {
//         _command = val.recognizedWords.toLowerCase();
//         _handleVoiceCommand(_command);
//       });
//     });
//   }
//
//   // Stop listening
//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {
//       _isListening = false;
//     });
//   }
//
//   // Handle voice commands
//   void _handleVoiceCommand(String command) {
//     if (command.contains('open object detection')) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (context) => RealTimeObjectDetection(cameras: cameras!)));
//     } else if (command.contains('open map')) {
//       MapUtils.openMap(25.31668000, 83.01041000);
//     } else if (command.contains('open chatbot')) {
//       _openGoogleVoiceSearch();
//     }
//   }
//
//   Future<void> _openGoogleVoiceSearch() async {
//     const String url = 'https://www.google.com/voice';
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (cameras == null) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     return Scaffold(
//       backgroundColor: const Color(0xFF393767),
//       body: SingleChildScrollView(
//         // This makes the page scrollable
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Transform.rotate(
//                   origin: const Offset(30, -60),
//                   angle: 2.4,
//                   child: Container(
//                     margin: const EdgeInsets.only(left: 75, top: 40),
//                     height: 400,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(80),
//                       gradient: const LinearGradient(
//                         begin: Alignment.bottomLeft,
//                         colors: [Color(0xFFFD4497), Color(0xffFD8BAB)],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Virtual Eye',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       const Text(
//                         'A Supporting App For Blind Person',
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 60),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 CatigoryW(
//                                   image: 'images/object.jpg',
//                                   text: 'Object Detection',
//                                   color: const Color(0xFF0C77C0),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             RealTimeObjectDetection(
//                                                 cameras: cameras!),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 CatigoryW(
//                                   image: 'images/map-locator.png',
//                                   text: ' Map',
//                                   color: const Color(0xFFFD8C44),
//                                   onPressed: () async {
//                                     await MapUtils.openMap(
//                                         25.31668000, 83.01041000);
//                                   },
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 CatigoryW(
//                                   image: 'images/chatbot.png',
//                                   text: 'Chatbot',
//                                   color: const Color(0xFF47B4FF),
//                                   onPressed: _openGoogleVoiceSearch,
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                             ElevatedButton(
//                               onPressed: _isListening ? _stopListening : _startListening,
//                               child: Text(_isListening ? 'Stop Listening' : 'Start Voice Command'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
