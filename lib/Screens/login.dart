
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/Screens/Home.dart';
import 'package:flutter_test1/Screens/RegisterPage.dart';
import 'package:flutter_test1/components/errorOnlineLog.dart';
import 'package:flutter_test1/components/mybutton.dart';
import 'package:flutter_test1/components/tetxfield.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void signUserIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final users = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      final user = await FirebaseAuth.instance.currentUser;
      debugPrint(user!.uid.toString());
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        dynamic data = documentSnapshot.data();
        debugPrint(data.toString());
        final wholesaler = data['role'];
       
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
      } else {
        debugPrint('Document does not exist');
      }
    } catch (error) {
      debugPrint(error.toString());
      logErrorToFirestore(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    
                    Image.asset(
                      'images/word.jpeg',
                      width: MediaQuery.of(context).size.width*90,
                      height: 100,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Welcome back! You\'ve been missed',
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 8, 8),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    MyTextFeild(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    MyTextFeild(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'forgot password?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 97, 96, 96)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ), 
                    MyButton(
                      text: "Sign In",
                      onTap: () {
                        signUserIn();
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a Member? ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 97, 96, 96)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(
                                    onTap: () {},
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Register Now',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 30, 137, 236),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}