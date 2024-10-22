import 'package:flutter/material.dart';
import 'package:login_page/Widget/button.dart';
import 'package:login_page/Widget/snackbar.dart';
import 'package:login_page/Widget/text.dart';
import 'package:login_page/home_Page_flutter/homepage.dart';
import 'package:login_page/login_signup/fingerprint_auth.dart'; // Import the VoiceFingerprintAuth class
import 'package:login_page/login_signup/signup.dart';
import 'package:login_page/services/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final VoiceFingerprintAuth voiceFingerprintAuth = VoiceFingerprintAuth(); // Create an instance of VoiceFingerprintAuth

  @override
  void initState() {
    super.initState();
    voiceFingerprintAuth.announceInitialPrompt(); // Announce prompt when the app starts
  }

  void loginUser() async {
    String res = await AuthServices().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    if (res == "Success") {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  // Method to trigger voice command and fingerprint authentication
  // void loginWithVoiceAndFingerprint() async {
  //   // Start listening for the "fingerprint" command
  //   voiceFingerprintAuth.startListening((String recognizedWords) async {
  //     if (recognizedWords.toLowerCase().contains('fingerprint')) {
  //       voiceFingerprintAuth.stopListening(); // Stop listening once the command is recognized
  //       await voiceFingerprintAuth.speak("Apply your fingerprint"); // Announce when to apply fingerprint
  //       bool isAuthenticated = await voiceFingerprintAuth.authenticate(context);
  //       if (isAuthenticated) {
  //         Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (context) => const HomeScreen(),
  //         ));
  //       }
  //     }
  //   });

  void loginWithVoiceAndFingerprint() async {
    try {
      // Start listening for the "fingerprint" command
      voiceFingerprintAuth.startListening((String recognizedWords) async {
        if (recognizedWords.toLowerCase().contains('fingerprint')) {
          voiceFingerprintAuth.stopListening(); // Stop listening once the command is recognized
          //await voiceFingerprintAuth.speak("Apply your fingerprint"); // Announce when to apply fingerprint
          bool isAuthenticated = await voiceFingerprintAuth.authenticate(context);
          if (isAuthenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
          }
        }
      });
    } catch (e) {
      print('Error during voice and fingerprint authentication: $e');  // Log the error
      showSnackBar(context, 'Authentication error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: loginWithVoiceAndFingerprint, // Trigger voice and fingerprint authentication on tap anywhere
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: height / 2.7,
                    child: Image.asset("images/login.jpg"),
                  ),
                  TextFieldInput(
                    icon: Icons.person,
                    textEditingController: emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.text,
                  ),
                  TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  MyButtons(onTap: loginUser, text: "Log In"),

                  SizedBox(height: height / 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?", style: TextStyle(fontSize: 16)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
