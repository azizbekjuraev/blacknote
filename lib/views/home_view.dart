import 'package:blacknote/style/app_styles.dart';
import 'package:flutter/material.dart';
import '../widgets/reusable_icon_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
            onPressed: () {},
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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/home_icon.png'),
                const Text(
                  'Create your first note !',
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                tooltip: 'Add new note',
                onPressed: () async {},
                backgroundColor: AppStyles.primaryBgColor,
                child: const Icon(
                  Icons.add,
                  color: AppStyles.backgroundColorWhite,
                  size: 48,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
