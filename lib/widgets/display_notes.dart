import 'package:blacknote/style/app_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayNotesUI extends StatefulWidget {
  @override
  _DisplayNotesUIState createState() => _DisplayNotesUIState();
}

class _DisplayNotesUIState extends State<DisplayNotesUI> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    // Call the displayNotes function when the widget is created
    _fetchAndDisplayNotes();
  }

  Future<List<Map<String, dynamic>>> displayNotes() async {
    try {
      String userUid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference notesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('notes');

      // Fetch notes from Firestore
      QuerySnapshot querySnapshot = await notesCollection.get();

      List<Map<String, dynamic>> fetchedNotes = [];

      // Display notes
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> noteData = doc.data() as Map<String, dynamic>;
        debugPrint(
            'Title: ${noteData['title']}, Content: ${noteData['content']}');
        fetchedNotes.add(noteData);
      }

      return fetchedNotes;
    } catch (e) {
      debugPrint('Error fetching notes: $e');
      return [];
    }
  }

  Future<void> _fetchAndDisplayNotes() async {
    // Call the displayNotes function to fetch notes
    List<Map<String, dynamic>> fetchedNotes = await displayNotes();

    setState(() {
      notes = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Display the notes in a ListView
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: AppStyles.buttonBgColorGreen,
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(
                          'Title: ${notes[index]['title']}',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
