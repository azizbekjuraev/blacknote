import 'package:blacknote/style/app_styles.dart';
import 'package:flutter/material.dart';

class CustomVisibility extends StatelessWidget {
  final bool visible;
  final String text;
  const CustomVisibility(
      {Key? key,
      required this.visible,
      this.text = 'Start searching your notes.'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/search_error.png'),
              Text(
                text,
                style: const TextStyle(
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
    );
  }
}
