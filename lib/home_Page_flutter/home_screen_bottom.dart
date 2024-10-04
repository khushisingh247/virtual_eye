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

class HomeScreenBottom extends StatefulWidget {
  const HomeScreenBottom({super.key, required cameras});

  @override
  State<HomeScreenBottom> createState() => _HomeScreenBottomState();
}

class _HomeScreenBottomState extends State<HomeScreenBottom> {
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    initializeCameras();
  }

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (cameras == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Color(0xFF393767),
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
                        colors: [ Color(0xFFFD4497),Color(0xffFD8BAB)],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
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
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'A Supporting App For Blind Person',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CatigoryW(
                                  image: 'images/object.jpg',
                                  text: 'Object Detection',
                                  color: const Color(0xFF0C77C0),

                                  //color:Colors.black,
                                  onPressed: () {  Navigator.push(context, MaterialPageRoute(builder: (context)=>RealTimeObjectDetection(cameras: cameras!)));},
                                ),
                                CatigoryW(
                                  image: 'images/map-locator.png',
                                  text: ' Map',
                                  color: const Color(0xFFFD8C44), onPressed: () async{ await MapUtils.openMap(25.31668000,83.01041000 ); },

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
                                  color: Color(0xFF47B4FF),
                                  //color: Color(0xFFA885FF),
                                  onPressed: () {    },
                                ),
                                // CatigoryW(
                                //   image: 'images/map-locator.png',
                                //   text: 'Object Detection',
                                //   color: const Color(0xFF47B4FF), onPressed: () {  },
                                // ),
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
    );
  }
}

