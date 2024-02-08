import 'dart:math';
import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/utils/show_toast.dart';
import 'package:blacknote/widgets/custom_text_field.dart';
import 'package:blacknote/widgets/reusable_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  bool isLoading = false;
  bool isEditing = false;
  late final TextEditingController _title;
  late final TextEditingController _content;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime dateTime = DateTime.now();

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

    final randomIndex = Random().nextInt(colorList.length);

    return colorList[randomIndex];
  }

  Future<void> addNote() async {
    try {
      if (!context.mounted) return;
      FocusScope.of(context).unfocus();

      setState(() {
        isLoading = true;
      });
      String userUid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          _firestore.collection('users').doc(userUid);

      Map<String, dynamic> userData = {
        'userId': userUid,
      };
      await userDocRef.set(userData);

      CollectionReference notesCollection = userDocRef.collection('notes');

      if (_title.text == "" || _content.text == "") {
        if (!context.mounted) return;
        showToast(
            context,
            title: "Error!",
            "Title and type fields can't be empty!",
            toastAlignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 0.0));
        return;
      } else {
        String createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
        List<int> randomColor = getRandomColor(myColors);

        Map<String, dynamic> noteData = {
          'title': _title.text,
          'content': _content.text,
          'container_color': randomColor,
          'created_at': createdAt,
        };

        // Add the note data to the 'notes' subcollection
        await notesCollection.add(noteData);
      }

      if (!context.mounted) return;
      showToast(
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
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
        actions: [
          ReusableIconButton(
            iconData: isEditing ? Icons.edit : Icons.remove_red_eye_outlined,
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
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
                    readOnly: isEditing ? true : false,
                    controller: _title,
                    maxLength: 100,
                    maxLines: null,
                    autofocus: true,
                    hintText: 'Title',
                    fontSize: 35,
                  ),
                  CustomTextField(
                    readOnly: isEditing ? true : false,
                    controller: _content,
                    maxLines: null,
                    hintText: 'Type something...',
                    fontSize: 23,
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        ],
      ),
      backgroundColor:
          isLoading ? AppStyles.primaryBgColor : AppStyles.bgColorBlack,
    );
  }
}
