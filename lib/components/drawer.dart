import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test1/Screens/RegisterPage.dart';
import 'package:flutter_test1/Screens/login.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // Option 1 (default value):
  // double _minTextAdapt = 16.0;

  // Option 2 (late with initialization):
 

  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
         /* */
            ListTile(
              title: Text('Home'),
              onTap: () {
                // Navigate to home screen
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Feature 1'),
              onTap: () {
                // Navigate to feature 1
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Log out'),
              onTap: ()async {
                // Navigate to feature 2
                 await FirebaseAuth.instance.signOut();
                 Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(
                                  ),
                                ),
                              );
              },
            ),
            // Add more ListTile items for other features as needed
          ],
        ),
      );
  }
}
