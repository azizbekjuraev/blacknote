import 'dart:math';

import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/utils/alert_dialogue.dart';
import 'package:blacknote/widgets/custom_text_field.dart';
import 'package:blacknote/widgets/reusable_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  bool isLoading = false;
  late final TextEditingController _title;
  late final TextEditingController _content;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    _title = TextEditingController();
    _content = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  List<List<int>> myColors = [
    [255, 158, 158, 1],
    [145, 244, 143, 1],
    [255, 245, 153, 1],
    [158, 255, 255, 1],
    [182, 156, 255, 1],
  ];

  List<int> getRandomColor(List<List<int>> colorList) {
    if (colorList.isEmpty) {
      throw Exception("Color list is empty");
    }

    // Generate a random index within the range of the colorList
    final randomIndex = Random().nextInt(colorList.length);

    // Return the random color as a list of integers
    return colorList[randomIndex];
  }

  Future<void> addNote() async {
    try {
      setState(() {
        isLoading = true;
      });
      String userUid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          _firestore.collection('users').doc(userUid);

      // Your user data, including 'userId'
      Map<String, dynamic> userData = {
        'userId': userUid,
        // Add any other fields you need for your user
      };

      // Set the user data in the 'users' collection with the user's ID as the document ID
      await userDocRef.set(userData);

      // Now, create a reference to the 'notes' subcollection under the 'users' document
      CollectionReference notesCollection = userDocRef.collection('notes');

      if (_title.text == "" || _content.text == "") {
        if (!context.mounted) return;
        showAlertDialog(
            context,
            title: "Error!",
            "Title and type fields can't be empty!",
            toastAlignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 0.0));
        return;
      } else {
        List<int> randomColor = getRandomColor(myColors);
        Map<String, dynamic> noteData = {
          'title': _title.text,
          'content': _content.text,
          'container_color': randomColor,
        };

        // Add the note data to the 'notes' subcollection
        await notesCollection.add(noteData);
      }

      if (!context.mounted) return;
      showAlertDialog(
          context,
          title: "Great!",
          "You have added a new note!",
          toastType: ToastificationType.success,
          iconColor: AppStyles.buttonBgColorGreen,
          toastAlignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 0.0));
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error adding note: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: ReusableIconButton(
            iconData: Icons.chevron_left_outlined,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            ReusableIconButton(
              iconData: Icons.remove_red_eye_outlined,
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ReusableIconButton(
                iconData: Icons.save_outlined,
                onPressed: () async {
                  await addNote();
                },
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _title,
                      maxLength: 100,
                      maxLines: null,
                      autofocus: true,
                      hintText: 'Title',
                      fontSize: 35,
                    ),
                    CustomTextField(
                      controller: _content,
                      maxLines: null,
                      hintText: 'Type something...',
                      fontSize: 23,
                    ),
                  ],
                ),
              ),
            ),
            // Loading Indicator and Dim Background
            if (isLoading)
              const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
          ],
        ));
  }
}
