import 'package:flutter/material.dart';
import 'package:login_page/Widget/button.dart';
import 'package:login_page/Widget/snackbar.dart';
import 'package:login_page/Widget/text.dart';
import 'package:login_page/home_Page_flutter/homepage.dart';
import 'package:login_page/login_signup/login_page.dart';
import 'package:login_page/services/authentication.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController=TextEditingController();
  bool isLoading = false;

  void despose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signUpUser() async{
    String res=await AuthServices().signUpUser(
        email:emailController.text,
        password: passwordController.text,
        name: nameController.text,
    );
    if(res=="Success"){
      setState(() {
        isLoading=true;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context)=>const HomeScreen(),
      ));
    }
    else{
      setState(() {
        isLoading=false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
          child:SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: height/2.7,
                    child:Image.asset("images/signup.jpeg"),
                  ),
                  TextFieldInput(
                      icon: Icons.person,
                      textEditingController: nameController,
                      hintText: 'Enter your name',
                      textInputType: TextInputType.text),
                  TextFieldInput(
                      icon: Icons.email,
                      textEditingController: emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.text),
                  TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
            
            
                  MyButtons(onTap: signUpUser, text: "Sign Up"),
                  SizedBox(height: height/15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ",style: TextStyle(fontSize: 16),),
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 16,color:Colors.blue,
                          ),),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
