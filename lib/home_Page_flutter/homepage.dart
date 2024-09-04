import 'package:flutter/material.dart';
import 'package:login_page/home_Page_flutter/community.dart';
import 'package:login_page/home_Page_flutter/home_screen_bottom.dart';
import 'package:login_page/home_Page_flutter/services_bottom.dart';
import 'package:login_page/login_signup/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

//import '../../Login With Google/google_auth.dart';
import '../Widget/button.dart';
//import 'login.dart';

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
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for bottom navigation
  int myIndex=0;
  List<Widget> widgetList=const[
  HomeScreenBottom(),
    ServicesBottom(),
    Community(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        children: widgetList,
        index: myIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,       // Sets the color of the selected icon
        unselectedItemColor: Colors.white70,
        onTap: (index){
          setState(() {
            if (index == 3) {
              // Log Out selected
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            } else {
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

