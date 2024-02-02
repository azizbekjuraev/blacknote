import 'dart:ffi';

import 'package:blacknote/style/app_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayNotesUI extends StatelessWidget {
  const DisplayNotesUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Use StreamBuilder to automatically update the UI
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getNotesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Display the notes in a ListView
                    List<Map<String, dynamic>> notes = snapshot.data!.docs
                        .map((doc) => (doc.data() as Map<String, dynamic>))
                        .toList();
                    return ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        List<double> colorValues =
                            (notes[index]['container_color'] as List<dynamic>?)
                                    ?.map((value) => (value as num).toDouble())
                                    .toList() ??
                                [255.0, 255.0, 255.0, 1.0];

                        Color containerColor = Color.fromRGBO(
                          colorValues[0].toInt(),
                          colorValues[1].toInt(),
                          colorValues[2].toInt(),
                          colorValues[3],
                        );
                        return Card(
                          color: containerColor,
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              title: Text(
                                '${notes[index]['title']}',
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getNotesStream() {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference notesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('notes');

    // Return a stream of snapshots
    return notesCollection.snapshots();
  }
}
