import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/Screens/login.dart';
import 'package:flutter_test1/components/errorOnlineLog.dart';
import 'package:flutter_test1/components/mybutton.dart';
import 'package:flutter_test1/components/tetxfield.dart';


class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, this.onTap});
  final Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  //sign up method
  void signUserUp() async {
    setState(() {
      isLoading = true;
    });
    if (passwordController.text == confirmPasswordController.text) {
      try {
          UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      final user = await FirebaseAuth.instance.currentUser;
      await user!.updateDisplayName(nameController.text);
      
      //after creating the user, create a new document in cloud firestore called users
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({
        'username': nameController.text,
        'phonenumber': phoneController.text,
        'email': emailController.text,
        'admin':false,
        'uid': userCredential.user!.uid,
      });
     
      setState(() {
        isLoading = false;
      });
       Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(
                                    
                                  ),
                                ),
                              );
      }
      catch(e){
        if (e is FirebaseException) {
      // Firebase exceptions
      print('Firebase Exception: ${e.message}');
    } else {
      // Regular Dart exceptions
      print('Regular Exception: $e');
    }
    logErrorToFirestore(e.toString());
      }
    
    } else {
      print('password dont matc');
    }
  }
 final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  String selected = '';

  @override

  //text editing controller
 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(alignment: Alignment.center, children: [
        SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 35,
                  ),

                  //logo
                  Image.network(
                     'images/word.jpeg',
                      width:  MediaQuery.of(context).size.width*90,
                      height: 70,
                    ),

                  const SizedBox(
                    height: 30,
                  ),

                  //welcome back
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 8, 8, 8),
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //username
                  MyTextFeild(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //email
                  MyTextFeild(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //phonemumber
                  MyTextFeild(
                    controller: phoneController,
                    hintText: 'Phone Number',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //password
                  MyTextFeild(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //confirm password
                  MyTextFeild(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
              
               
                  const SizedBox(
                    height: 25,
                  ),

                  //button
                  MyButton(
                      text: "Sign Up",
                      
                      onTap: () {
                        print(emailController.text);
                        signUserUp();
                      }),
                  const SizedBox(
                    height: 25,
                  ),

                  //already a member login
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a Member? ',
                          style:
                              TextStyle(color: Color.fromARGB(255, 97, 96, 96)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                color: Color.fromARGB(255, 30, 137, 236),
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
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
      ]),
    );
  }

  Widget loanPeriod(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 20, 0),
        child: Container(
          height: 40,
          width: 80,
          decoration: BoxDecoration(
              border: title == selected
                  ? Border.all(color:  Color.fromARGB(255, 138, 11, 160), width: 3)
                  : null,
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: Color.fromARGB(255, 138, 11, 160)),
            ),
          ),
        ),
      ),
    );
  }
}