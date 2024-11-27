import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import FlutterTTS

class ServicesBottom extends StatefulWidget {
  const ServicesBottom({super.key});

  @override
  State<ServicesBottom> createState() => _ServicesBottomState();
}

class _ServicesBottomState extends State<ServicesBottom> {
  final List<Map<String, String>> contacts = [
    {'name': 'Police', 'number': '112'},
    {'name': 'Fire Department', 'number': '+911234567890'},
    {'name': 'Ambulance', 'number': '+919876543210'},
    {'name': 'Person', 'number': '+917068766697'},
  ];

  final FlutterTts _flutterTts = FlutterTts(); // FlutterTts instance

  @override
  void initState() {
    super.initState();
    _initializeTTS(); // Ensure TTS is initialized
  }

  Future<void> _initializeTTS() async {
    try {
      // Initialize the TTS language and pitch settings
      await _flutterTts.setLanguage("en-IN");
      await _flutterTts.setPitch(1); // Adjust pitch if needed

      // Now, play the service message once initialized
      await _playServiceMessage();
    } catch (e) {
      print("Error initializing TTS: $e");
    }
  }

  Future<void> _playServiceMessage() async {
    try {
      // Check if TTS is ready before speaking
      bool isAvailable = await _flutterTts.isLanguageAvailable("en-IN");
      if (isAvailable) {
        await _flutterTts.speak("Welcome to services.");
      } else {
        print("TTS language not available.");
      }
    } catch (e) {
      print("Error playing welcome message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Services',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF404165),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact['name']!),
            subtitle: Text(contact['number']!),
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://tse1.mm.bing.net/th?id=OIP.8um7Q6EtY4wdtOT-DS0q2gHaHa&pid=Api&P=0&h=180',
              ),
            ),
            trailing: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue),
                ),
              ),
              child: const Text('Call'),
              onPressed: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: contact['number']);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch phone dialer')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ServicesBottom extends StatefulWidget {
//   const ServicesBottom({super.key});
//
//   @override
//   State<ServicesBottom> createState() => _ServicesBottomState();
// }
//
// class _ServicesBottomState extends State<ServicesBottom> {
//   final List<Map<String, String>> contacts = [
//     {'name': 'Police', 'number': '+91112'},
//     {'name': 'Fire Department', 'number': '+911234567890'},
//     {'name': 'Ambulance', 'number': '+919876543210'},
//     {'name': 'Person', 'number': '+917068766697'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Color(0xFF373856),
//       appBar: AppBar(
//         title: const Text(
//           'Services',
//           //backgroundColor: Color(0xFF373856),
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF404165),
//       ),
//       body: ListView.builder(
//         itemCount: contacts.length,
//         itemBuilder: (context, index) {
//           final contact = contacts[index];
//           return ListTile(
//             title: Text(contact['name']!),
//             subtitle: Text(contact['number']!),
//             leading: const CircleAvatar(
//               backgroundImage: NetworkImage(
//                 'https://tse1.mm.bing.net/th?id=OIP.8um7Q6EtY4wdtOT-DS0q2gHaHa&pid=Api&P=0&h=180',
//               ),
//             ),
//             trailing: TextButton(
//               style: TextButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 shape: const RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.blue),
//                 ),
//               ),
//               child: const Text('Call'),
//               onPressed: () async {
//                 final Uri phoneUri = Uri(scheme: 'tel', path: contact['number']);
//                 if (await canLaunchUrl(phoneUri)) {
//                   await launchUrl(phoneUri);
//                 } else {
//                   // Handle error
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Could not launch phone dialer')),
//                   );
//                 }
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
