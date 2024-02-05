import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/views/edit_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController searchController;
  late String userUid;
  late CollectionReference collection;
  List originalItems = [];
  List items = [];
  bool isNotMatched = true;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getNotes();
  }

  Future<void> getNotes() async {
    userUid = FirebaseAuth.instance.currentUser!.uid;
    collection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('notes');
    var data = await collection.get();
    setState(() {
      items = data.docs;
      originalItems = data.docs;
    });
  }

  getFilteredItems(String searchText) {
    List<Map<String, dynamic>> notes = originalItems
        .map((doc) => (doc.data() as Map<String, dynamic>))
        .toList();
    if (searchText.isEmpty) {
      return notes;
    } else {
      return notes
          .where((item) =>
              item['title'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    String searchText = searchController.text;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: SizedBox(
          height: 50,
          child: TextField(
            onChanged: (text) {
              setState(() {
                if (searchText.isEmpty) {
                  items = [];
                }
                items = getFilteredItems(text);
                isNotMatched = items.isEmpty ? true : false;
              });
            },
            controller: searchController,
            autofocus: true,
            style: const TextStyle(color: AppStyles.backgroundColorWhite),
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () {
                  if (searchText.isNotEmpty) {
                    searchController.text = '';
                    setState(() {
                      items = [];
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.close,
                  color: AppStyles.backgroundColorWhite,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              filled: true,
              hintStyle: const TextStyle(color: AppStyles.backgroundColorWhite),
              hintText: "Search by the keyword...",
              fillColor: AppStyles.primaryBgColor,
            ),
          ),
        ),
      ),
      body: Stack(children: [
        Visibility(
          visible: searchText.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Positioned(
                top: 0,
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    List<double> colorValues =
                        (items[index]['container_color'] as List<dynamic>?)
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
                          horizontalTitleGap: 3.0,
                          title: Text(
                            items[index]['title'],
                            style: const TextStyle(fontSize: 25),
                          ),
                          onTap: () {
                            String documentId = originalItems[index].id;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditView(noteData: [
                                  items[index]['title'],
                                  items[index]['content'],
                                  documentId,
                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )),
          ),
        ),
        searchText.isEmpty
            ? Visibility(
                visible: searchText.isEmpty,
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/search_error.png'),
                        const Text(
                          'Start searching your notes.',
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
                ),
              )
            : Visibility(
                visible: isNotMatched,
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/search_error.png'),
                        const Text(
                          'Note not found. Try searching again.',
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
                ),
              ),
      ]),
    );
  }
}
