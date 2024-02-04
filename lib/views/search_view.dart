import 'package:blacknote/style/app_styles.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: SizedBox(
          height: 50,
          child: TextField(
            autofocus: true,
            style: const TextStyle(color: AppStyles.backgroundColorWhite),
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/search_error.png'),
            const Text(
              'File not found. Try searching again.',
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
    );
  }
}
