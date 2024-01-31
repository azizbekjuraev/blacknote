import 'package:blacknote/style/app_styles.dart';
import 'package:flutter/material.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Notes',
            style: TextStyle(
                color: AppStyles.backgroundColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 43),
          ),
          actions: [
            IconButton(
              icon: Image.asset('assets/see_icon.png'),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset('assets/disclaimer_icon.png'),
              onPressed: () {},
            ),
          ],
        ),
        body: Container());
  }
}
