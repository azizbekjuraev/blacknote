import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/utils/show_alert.dart';
import 'package:blacknote/utils/show_toast.dart';
import 'package:blacknote/widgets/custom_text_field.dart';
import 'package:blacknote/widgets/reusable_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class EditView extends StatefulWidget {
  final List<String>? noteData;
  const EditView({super.key, this.noteData});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  bool isLoading = false;
  bool isEditing = false;
  late final TextEditingController _title;
  late final TextEditingController _content;
  late final String originalTitle;
  late final String originalContent;

  @override
  void initState() {
    _title = TextEditingController(text: widget.noteData?[0]);
    _content = TextEditingController(text: widget.noteData?[1]);
    originalTitle = widget.noteData?[0] ?? "";
    originalContent = widget.noteData?[1] ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  bool isNoteChanged() {
    return _title.text != originalTitle || _content.text != originalContent;
  }

  Future<void> updateNote() async {
    try {
      if (!context.mounted) return;
      FocusScope.of(context).unfocus();

      isNoteChanged();
      if (!isNoteChanged()) return;

      setState(() {
        isLoading = true;
      });

      String userUid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('notes')
          .doc(widget.noteData?[2])
          .update({'title': _title.text, 'content': _content.text});

      if (!context.mounted) return;
      showToast(
          context,
          title: "Great!",
          "You have successfully edited your note!",
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
              if (!isNoteChanged()) {
                return Navigator.pop(context);
              } else {
                showAlert(context,
                    title: 'Are your sure you want discard your changes ?');
              }
            },
          ),
          actions: [
            ReusableIconButton(
              iconData: isEditing ? Icons.remove_red_eye_outlined : Icons.edit,
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
                  // await updateNote();
                  if (isNoteChanged()) {
                    showAlert(context,
                        updateNote: updateNote, greenBtnText: 'Save');
                  }
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
                      readOnly: isEditing ? false : true,
                      controller: _title,
                      maxLength: 100,
                      maxLines: null,
                      autofocus: true,
                      hintText: 'Title',
                      fontSize: 35,
                    ),
                    CustomTextField(
                      readOnly: isEditing ? false : true,
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
        ));
  }
}
