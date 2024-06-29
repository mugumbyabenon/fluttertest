import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/components/drawer.dart';
import 'package:flutter_test1/components/errorOnlineLog.dart';

class userItemsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
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
                        Text(data['username'] ?? 'No Title'),
                        TextButton(style: TextButton.styleFrom(
                            backgroundColor:data['admin']==false ? Colors.green:Colors.red, // Set background color
                             // Set text color
                          ),onPressed: ()async{
                            try {
                                await FirebaseFirestore.instance.collection('Users').doc(data['uid']).update({
                                  'admin':data['admin']==false?true:false,
                                  
                                });
                    print('Document updated successfully');
                            }catch(e){
                        debugPrint(e.toString());
                        logErrorToFirestore(e.toString());
                            }
                          }, child: Text('${data['admin']==false?"Make Admin":"Remove Admin"}',style: TextStyle(
                            color: Colors.white
                          ),))
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
