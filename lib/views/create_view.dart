import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/widgets/custom_text_field.dart';
import 'package:blacknote/widgets/reusable_icon_button.dart';
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
          toolbarHeight: 60,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: ReusableIconButton(
            iconData: Icons.chevron_left_outlined,
            onPressed: () {},
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
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  maxLength: 100,
                  maxLines: null,
                  autofocus: true,
                  hintText: 'Title',
                  fontSize: 35,
                ),
                CustomTextField(
                  maxLines: null,
                  hintText: 'Type something...',
                  fontSize: 23,
                ),
              ],
            ),
          ),
        ));
  }
}
