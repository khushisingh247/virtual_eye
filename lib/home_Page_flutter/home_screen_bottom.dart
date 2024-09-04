import 'package:flutter/material.dart';
import 'package:login_page/Widget/button.dart';
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
  const HomeScreenBottom({super.key});

  @override
  State<HomeScreenBottom> createState() => _HomeScreenBottomState();
}

class _HomeScreenBottomState extends State<HomeScreenBottom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Virtual Eye',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select any button to proceed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            MyButtons(
              onTap: () async {
                await MapUtils.openMap(25.31668000,83.01041000 );
              },

              text: "Object Detection",
            ),
            MyButtons(
              onTap: () async {
                await MapUtils.openMap(25.31668000,83.01041000 );
              },
              text: "Open Google Maps",
            ),
            MyButtons(
              onTap: () async {
                await MapUtils.openMap(25.31668000,83.01041000 );
              },
              text: "Voice Assistant Chatbot",
            ),

          ],
        ),
      ),

    );
  }
}
