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
        content: SizedBox(
          width: 330,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info,
                color: AppStyles.iconColor,
              ),
              const SizedBox(height: 22),
              Text(
                textAlign: TextAlign.center,
                title,
                style: const TextStyle(
                  color: AppStyles.backgroundColorWhite,
                  fontSize: 23,
                ),
              ),
              const SizedBox(height: 22),
              Row(
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
                          FocusScope.of(context).unfocus();
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
            ],
          ),
        ),
      );
    },
  );
}
