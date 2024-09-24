import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Community extends StatelessWidget {
  const Community({super.key});

  // Function to open YouTube Music link
  void _openYouTubeMusic() async {
    final Uri url = Uri.parse('https://music.youtube.com/'); // YouTube Music link

    // Attempt to launch the URL
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Open it in an external app (like browser or YouTube Music)
      );
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Open YouTube Music when the Community screen is opened
    _openYouTubeMusic();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Screen'),
      ),
      body: const Center(
        child: Text('Opening YouTube Music...'),
      ),
    );
  }
}
