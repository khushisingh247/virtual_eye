import 'package:flutter/material.dart';
import 'package:login_page/home_Page_flutter/community.dart';
import 'package:login_page/home_Page_flutter/home_screen_bottom.dart';
import 'package:login_page/home_Page_flutter/services_bottom.dart';
import 'package:login_page/login_signup/login_page.dart';
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
  // For bottom navigation
  int myIndex = 0;
  List<CameraDescription>? cameras; // Declare cameras here
  List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();
    initializeCameras(); // Initialize cameras when the state is created
  }

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    setState(() {
      widgetList = [
        HomeScreenBottom(cameras: cameras!), // Pass cameras to HomeScreenBottom
        const ServicesBottom(),
        const Community(),
      ];
    });
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
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
    return Scaffold(
      body: IndexedStack(
        children: widgetList.isEmpty
            ? [Center(child: CircularProgressIndicator())] // Show loading indicator until cameras are initialized
            : widgetList,
        index: myIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor:  Color(0xFF373856),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          setState(() {
            if (index == 3) {
              _showLogoutConfirmationDialog();
            }else if (index == 2) {
              // Community tab is selected, open YouTube Music
              _openYouTubeMusic();
            }
            else {
              // Update the selected index
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
    );
  }
}
