import 'package:blacknote/style/app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final int? maxLength;
  final int? maxLines;
  final bool autofocus;
  final String hintText;
  final double fontSize;

  const CustomTextField({
    Key? key,
    this.maxLength,
    this.maxLines,
    this.autofocus = false,
    this.hintText = '',
    this.fontSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      maxLines: maxLines,
      autofocus: autofocus,
      style: TextStyle(
        color: AppStyles.backgroundColorWhite,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppStyles.primaryTextColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
