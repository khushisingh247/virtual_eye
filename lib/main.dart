import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:login_page/home_Page_flutter/homedemo.dart';
import 'package:login_page/home_Page_flutter/homepage.dart';
import 'package:login_page/login_signup/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: MyApp(), // Your main app widget
    ),
  );
}

class MyApp extends StatelessWidget {


  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const Homedemo(),
      home: const LoginPage(),
      //home:  const HomeScreen(),
    );
  }
}


