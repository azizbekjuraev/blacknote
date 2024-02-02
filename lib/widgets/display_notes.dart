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

                        return Dismissible(
                          key: Key('${notes[index]['title']}'),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            String documentId = snapshot.data!.docs[index].id;
                            return await deleteNote(context, documentId);
                          },
                          background: const Padding(
                            padding: EdgeInsets.all(05.0),
                            child: Card(
                              color: AppStyles.deleteBgColor,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Card(
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
    return notesCollection.snapshots();
  }

  Future<bool> deleteNote(BuildContext context, String noteId) async {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    bool isDeleted = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppStyles.bgColorBlack,
          title: const Text(
            'Confirm Deletion',
            style:
                TextStyle(fontSize: 23, color: AppStyles.backgroundColorWhite),
          ),
          content: const Text(
            'Are you sure you want to delete this note?',
            style:
                TextStyle(fontSize: 23, color: AppStyles.backgroundColorWhite),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: AppStyles.backgroundColorWhite, fontSize: 18),
              ),
            ),
            SizedBox(
              width: 112,
              height: 39,
              child: FloatingActionButton(
                autofocus: true,
                foregroundColor: AppStyles.backgroundColorWhite,
                splashColor: AppStyles.backgroundColorWhite,
                backgroundColor: AppStyles.deleteBgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                onPressed: () {
                  Navigator.of(context).pop();
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userUid)
                      .collection('notes')
                      .doc(noteId)
                      .delete();

                  isDeleted = true;
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        );
      },
    );

    return isDeleted;
  }
}
