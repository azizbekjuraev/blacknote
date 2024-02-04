import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/widgets/display_notes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/reusable_icon_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Notes',
          style: TextStyle(
              color: AppStyles.backgroundColorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 43),
        ),
        actions: [
          ReusableIconButton(
            iconData: Icons.search,
            onPressed: () {
              Navigator.pushNamed(context, './search-view/');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ReusableIconButton(
              iconData: Icons.info_outline,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('notes')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // If there are no notes, show Align widget
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/home_icon.png'),
                      const Text(
                        'Create your first note!',
                        style: TextStyle(
                          color: AppStyles.backgroundColorWhite,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 60.0,
                  right: 20,
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: FloatingActionButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      tooltip: 'Add new note',
                      onPressed: () {
                        Navigator.pushNamed(context, './create-view/');
                      },
                      backgroundColor: AppStyles.primaryBgColor,
                      child: const Icon(
                        Icons.add,
                        color: AppStyles.backgroundColorWhite,
                        size: 48,
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            // If there are notes, show DisplayNotesUI widget
            return Stack(
              children: [
                const DisplayNotesUI(),
                Positioned(
                  bottom: 60.0,
                  right: 20,
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: FloatingActionButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      tooltip: 'Add new note',
                      onPressed: () {
                        Navigator.pushNamed(context, './create-view/');
                      },
                      // backgroundColor: AppStyles.primaryBgColor,
                      child: const Icon(
                        Icons.add,
                        color: AppStyles.backgroundColorWhite,
                        size: 48,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
