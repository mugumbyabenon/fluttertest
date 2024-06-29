
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
                    
                    Image.network(
                      'data:image/jpeg;base64,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',
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