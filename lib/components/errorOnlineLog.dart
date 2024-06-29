import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

Future<void> logErrorToFirestore(String errorMessage) async {
  try {
    // Create a reference to the Firestore collection
    CollectionReference errorLogs = FirebaseFirestore.instance.collection('error_logs');

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Define user details and current timestamp
    String userId = user?.uid ?? 'No user ID';
    String userEmail = user?.email ?? 'No email';
    String username = user?.displayName ?? 'No username';
    String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Only date

    // Create a map for the error details
    Map<String, dynamic> errorDetails = {
      'timestamp': timestamp,
      'date': date,
      'errorMessage': errorMessage,
    };

    // Add user details if the user is logged in
    if (user != null) {
      errorDetails.addAll({
        'userId': userId,
        'email': userEmail,
        'username': username,
      });
    }

    // Add a new document with error details
    await errorLogs.add(errorDetails);

    print('Error logged to Firestore successfully.');
  } catch (e) {
    print('Failed to log error: ${e.toString()}');
  }
}
