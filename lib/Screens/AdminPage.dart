import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/Screens/Wordslist.dart';
import 'package:flutter_test1/Screens/userlists.dart';
import 'package:flutter_test1/components/DetermineAdmin.dart';
import 'package:flutter_test1/components/drawer.dart';
import 'package:intl/intl.dart';

class ItemsListScreen extends StatelessWidget {
   void _showInputDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Word'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter a word'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String word = _controller.text.trim();
                if (word.isNotEmpty) {
                  _addWordToFirestore(word);
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Handle empty input (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a word')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Method to add the word to Firestore
  Future<void> _addWordToFirestore(String word) async {
    try {
      // Generate a unique ID based on current timestamp and random component
      String uniqueId = _generateUniqueId();

      // Create a reference to the document with the unique ID
      DocumentReference docRef = FirebaseFirestore.instance.collection('words').doc(uniqueId);

      // Set data for the document
      await docRef.set({
        'word': word,
        'id': uniqueId, // Store the unique ID as a field
        'timestamp': FieldValue.serverTimestamp(),
        'obtained':false // Optional: add a timestamp
      });

      print('Word added to Firestore with ID: $uniqueId');
    } catch (e) {
      print('Error adding word: $e');
    }
  }
    String _generateUniqueId() {
    // Get current timestamp
    String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    // Optionally, add a random component for additional uniqueness
    String randomComponent = DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);

    return '$timestamp$randomComponent';
  }
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: isCurrentUserAdmin(),
      builder: (context,snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold( appBar: AppBar(
            title: Text('Admin'),
          ),drawer: AppDrawer(),body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(
               appBar: AppBar(
            title: Text('Admin'),
          ),
              drawer: AppDrawer(),body: Center(child: Text('Error: ${snapshot.error}')));
          } else if (!snapshot.hasData || !snapshot.data!) {
            return Scaffold(
               appBar: AppBar(
            title: Text('Admin'),
          ),
              drawer: AppDrawer(),
              body: Center(child: Text('You are not an admin. Login with email:legacyallan0@gmail.com and password:1234567890, to make the current user admin',style: TextStyle(
                fontSize: 14
              ),)));
          } else {
        return Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
            title: Text('Admin'),
          ),
          body:SizedBox(
           // height: 800,
            child: Column(children: [
             const Center(child: Text('Users List',style: TextStyle(fontSize: 20),),),
              userItemsListScreen(),
              Center(child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text('Words List',style: TextStyle(fontSize: 20),),
                   IconButton( onPressed: () => _showInputDialog(context), icon: Icon(Icons.add))
                 ],
               ),),
              WordsItemsListScreen()
            ],))
         );
      }
  }); }
}
