import 'package:blacknote/style/app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final int? maxLength;
  final int? maxLines;
  final bool autofocus;
  final bool readOnly;
  final String hintText;
  final double fontSize;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    this.maxLength,
    this.maxLines,
    this.autofocus = false,
    this.hintText = '',
    this.fontSize = 16.0,
    this.readOnly = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
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
