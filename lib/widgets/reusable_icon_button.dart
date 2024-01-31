import 'package:blacknote/style/app_styles.dart';
import 'package:flutter/material.dart';

class ReusableIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const ReusableIconButton({
    super.key,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: AppStyles.primaryBgColor,
      ),
      child: IconButton(
        icon: Icon(
          iconData,
          color: AppStyles.backgroundColorWhite,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
