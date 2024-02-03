import 'package:blacknote/style/app_styles.dart';
import 'package:flutter/material.dart';

void showAlert(BuildContext context,
    {Future<void> Function()? updateNote,
    String greenBtnText = 'Keep',
    String title = 'Save changes?'}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppStyles.bgColorBlack,
        icon: const Center(
          child: Icon(
            Icons.info,
            color: AppStyles.backgroundColorWhite,
          ),
        ),
        title: Center(
          child: Text(
            title,
            style: const TextStyle(color: AppStyles.backgroundColorWhite),
          ),
        ),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 112,
                  height: 39,
                  child: FloatingActionButton(
                    autofocus: true,
                    foregroundColor: AppStyles.backgroundColorWhite,
                    splashColor: AppStyles.backgroundColorWhite,
                    backgroundColor: AppStyles.deleteBgColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () {
                      if (updateNote is Function) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Discard',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  width: 112,
                  height: 39,
                  child: FloatingActionButton(
                    autofocus: true,
                    foregroundColor: AppStyles.backgroundColorWhite,
                    splashColor: AppStyles.backgroundColorWhite,
                    backgroundColor: AppStyles.buttonBgColorGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () async {
                      if (updateNote is Function) {
                        await updateNote!();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      greenBtnText,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
