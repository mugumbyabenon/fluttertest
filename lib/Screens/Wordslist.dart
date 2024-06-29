import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/components/drawer.dart';
import 'package:flutter_test1/components/errorOnlineLog.dart';

class WordsItemsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('words').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items found'));
          } else {
            User? currentUser = FirebaseAuth.instance.currentUser;

            if (currentUser == null) {
              return Center(child: Text('No user logged in'));
            }

            List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return data['uid'] != currentUser.uid;
            }).toList();

            if (filteredDocs.isEmpty) {
              return Center(child: Text('No items found'));
            }

            return SizedBox(
              height: filteredDocs.length*100,
              child: ListView(
                children: filteredDocs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['word'] ?? 'No Title'),
                        IconButton(style: TextButton.styleFrom(
                            backgroundColor:Colors.red, // Set background color
                             // Set text color
                          ),onPressed: ()async{
                            try {
                              void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: ()async {
                // Handle the delete action here
                Navigator.of(context).pop(); // Close the dialog
                await FirebaseFirestore.instance.collection('words').doc(data['id']).delete();
                    print('Document updated successfully');// Call the delete method
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
         _showDeleteConfirmationDialog(context);                       
                            }catch(e){
                        debugPrint(e.toString());
                        logErrorToFirestore(e.toString());
                            }
                          }, icon: Icon(Icons.delete),)
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      );
  }
}
