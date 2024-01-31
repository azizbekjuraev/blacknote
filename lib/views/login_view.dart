import 'package:blacknote/style/app_styles.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColorBlack,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 43,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 41,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  style: const TextStyle(color: AppStyles.backgroundColorWhite),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    filled: true,
                    hintStyle:
                        const TextStyle(color: AppStyles.backgroundColorWhite),
                    hintText: "email",
                    fillColor: AppStyles.primaryBgColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 41,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  style: const TextStyle(color: AppStyles.backgroundColorWhite),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                    suffixIconColor: AppStyles.backgroundColorWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    filled: true,
                    hintStyle:
                        const TextStyle(color: AppStyles.backgroundColorWhite),
                    hintText: "password",
                    fillColor: AppStyles.primaryBgColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 53,
              ),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(
                        AppStyles.buttonBgColorGreen),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            100.0), // Set your desired border radius here
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Register',
                    style: TextStyle(
                        color: AppStyles.backgroundColorWhite, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 41,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, './register/');
                  },
                  child: const Text(
                    'If you do not have an account, register!',
                    style: TextStyle(
                        color: AppStyles.backgroundColorWhite, fontSize: 23),
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
