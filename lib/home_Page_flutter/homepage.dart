import 'package:flutter/material.dart';
//import 'package:login_page/home_Page_flutter/community.dart';
import 'package:login_page/home_Page_flutter/home_screen_bottom.dart';
import 'package:login_page/home_Page_flutter/services_bottom.dart';
import 'package:login_page/login_signup/login_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';  // For handling permissions
import 'package:url_launcher/url_launcher.dart';
import '../Widget/button.dart';
import 'package:camera/camera.dart';

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
  stt.SpeechToText _speechToText = stt.SpeechToText();  // Initialize SpeechToText
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
        HomeScreenBottom(cameras: cameras!),
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
        print('Recognized command: $_command');  // Debugging output
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

  void _handleVoiceCommand(String command) {
    if (command.contains('open services')) {
      setState(() {
        myIndex = 1;  // Navigate to "Services"
      });
    } else if (command.contains('open home')) {
      setState(() {
        myIndex = 0;  // Navigate to "Home"
      });
    } else if (command.contains('open community')) {
      setState(() {
        _openYouTubeMusic();// Navigate to "Community"
      });
    } else if (command.contains('log out')) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isListening) {
          _stopListening();
        } else {
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
          backgroundColor: const Color(0xFF373856),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: (index) {
            setState(() {
              if (index == 3) {
                _showLogoutConfirmationDialog();
              } else if (index == 2) {
                _openYouTubeMusic;
              } else {
                myIndex = index;
              }
            });
          },
          currentIndex: myIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Log Out',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_isListening) {
              _stopListening();
            } else {
              _startListening();
            }
          },
          child: Icon(_isListening ? Icons.mic_off : Icons.mic),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:login_page/home_Page_flutter/community.dart';
// import 'package:login_page/home_Page_flutter/home_screen_bottom.dart';
// import 'package:login_page/home_Page_flutter/services_bottom.dart';
// import 'package:login_page/login_signup/login_page.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../Widget/button.dart';
// import 'package:camera/camera.dart';
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
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   // For bottom navigation
//   int myIndex = 0;
//   List<CameraDescription>? cameras; // Declare cameras here
//   List<Widget> widgetList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeCameras(); // Initialize cameras when the state is created
//   }
//
//   Future<void> initializeCameras() async {
//     cameras = await availableCameras();
//     setState(() {
//       widgetList = [
//         HomeScreenBottom(cameras: cameras!), // Pass cameras to HomeScreenBottom
//         const ServicesBottom(),
//         const Community(),
//       ];
//     });
//   }
//
//   Future<void> _openYouTubeMusic() async {
//     final Uri url = Uri.parse('https://music.youtube.com/');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   Future<void> _showLogoutConfirmationDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // Prevents closing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Logout'),
//           content: const Text('Are you sure you want to log out?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('No'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//             TextButton(
//               child: const Text('Yes'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => const LoginPage(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         children: widgetList.isEmpty
//             ? [Center(child: CircularProgressIndicator())] // Show loading indicator until cameras are initialized
//             : widgetList,
//         index: myIndex,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         showUnselectedLabels: true,
//         backgroundColor:  Color(0xFF373856),
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white70,
//         onTap: (index) {
//           setState(() {
//             if (index == 3) {
//               _showLogoutConfirmationDialog();
//             }else if (index == 2) {
//               // Community tab is selected, open YouTube Music
//               _openYouTubeMusic();
//             }
//             else {
//               // Update the selected index
//               myIndex = index;
//             }
//           });
//         },
//         currentIndex: myIndex,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.call),
//             label: 'Services',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.group),
//             label: 'Community',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.logout),
//             label: 'Log Out',
//           ),
//         ],
//       ),
//     );
//   }
// }
