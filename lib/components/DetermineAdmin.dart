import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test1/components/errorOnlineLog.dart';

Future<bool> isCurrentUserAdmin() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is not null
    if (user == null) {
      return false;
    }

    // Get the user document from the Users collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    // Check if the document exists
    if (!userDoc.exists) {
      return false;
    }

    // Get the 'admin' field value
    bool isAdmin = userDoc.get('admin') ?? false;

    // Return whether the user is an admin
    return isAdmin;
  } catch (e) {
    // Handle errors
    print('Error checking admin status: ${e.toString()}');
    logErrorToFirestore('Error checking admin status: ${e.toString()}');
    return false;
  }
}
