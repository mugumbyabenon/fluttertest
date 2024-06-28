import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test1/Screens/RegisterPage.dart';
import 'package:flutter_test1/Screens/login.dart';
import 'package:flutter_test1/components/drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize screen utilities
    ScreenUtil.init(context, designSize: Size(360, 690));
 User? user = FirebaseAuth.instance.currentUser;
    return  user != null ? Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Your App!',
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                // Navigate to feature 1
              },
              child: Text('Feature 1'),
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () {
                // Navigate to feature 2
              },
              child: Text('Feature 2'),
            ),
            // Add more buttons for other features as needed
          ],
        ),
      ),
      drawer:AppDrawer(),
    ): LoginPage();
  }
}
