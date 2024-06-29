import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test1/Screens/RegisterPage.dart';
import 'package:flutter_test1/Screens/login.dart';
import 'package:flutter_test1/Screens/wordgame.dart';
import 'package:flutter_test1/components/drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize screen utilities
    //ScreenUtil.init(context, designSize: Size(60, 690));
 User? user = FirebaseAuth.instance.currentUser;
    return  user != null ? WordGame(): LoginPage();
  }
}
