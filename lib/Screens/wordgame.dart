import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/components/drawer.dart';
import 'package:flutter_test1/components/errorOnlineLog.dart';

class WordGame extends StatefulWidget {
  @override
  _WordGameState createState() => _WordGameState();
}

class _WordGameState extends State<WordGame> {
  final TextEditingController _controller = TextEditingController();
  int _score = 0;
  String _feedback = '';

  Future<void> _checkWord(String word) async {
    try {
      // Fetch all documents from the 'words' collection
      final querySnapshot = await FirebaseFirestore.instance.collection('words').get();

      // Extract the 'word' attribute from each document and store in a list
      List<String> wordList = querySnapshot.docs.map((doc) => doc['word'].toString()).toList();

      // Get the index of the provided word in the list
      int index = wordList.indexOf(word);

      // Check if the word exists in the list
      if (index != -1) {
        // Remove the word from the list
        wordList.removeAt(index);

        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          setState(() {
            _score++;
            _feedback = 'Correct!';
          });

          // Update the user's score in the 'scores' collection
          await FirebaseFirestore.instance.collection('scores').doc(user.uid).set({
            'score': _score,
          });

          // Optionally, remove the word from Firestore
          // This part will remove the word from Firestore collection
          // await FirebaseFirestore.instance.collection('words').doc(word).delete();
        } else {
          setState(() {
            _feedback = 'User not logged in!';
          });
        }
      } else {
        setState(() {
          _feedback = 'Incorrect!';
        });
      }
    } catch (e) {
      logErrorToFirestore(e.toString());
      setState(() {
        _feedback = 'Error: ${e.toString()}';
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Word Game'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('scores')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, scoreSnapshot) {
          if (scoreSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (scoreSnapshot.hasError) {
            return Center(child: Text('Error: ${scoreSnapshot.error}'));
          } else if (!scoreSnapshot.hasData) {
            return Center(child: Text('No score available'));
          }

          // Update the score
          if (scoreSnapshot.hasData) {
            _score = (scoreSnapshot.data!['score'] ?? 0) as int;
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('words').snapshots(),
            builder: (context, wordsSnapshot) {
              if (wordsSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (wordsSnapshot.hasError) {
                return Center(child: Text('Error: ${wordsSnapshot.error}'));
              } else if (!wordsSnapshot.hasData) {
                return Center(child: Text('No words available'));
              }

              // Extract the list of words
              List<String> wordList = wordsSnapshot.data!.docs.map((doc) => doc['word'].toString()).toList();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Enter a word',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final word = _controller.text.trim();
                        if (word.isNotEmpty) {
                          _checkWord(word);
                          _controller.clear();
                        }
                      },
                      child: Text('Check Word'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Score: $_score',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _feedback,
                      style: TextStyle(fontSize: 24, color: _feedback == 'Correct!' ? Colors.green : Colors.red),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
