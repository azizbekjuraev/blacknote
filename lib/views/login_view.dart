import 'package:blacknote/state/shared_preferences.dart';
import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/utils/show_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool isLoading = false;
  bool _obscureText = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      if (!context.mounted) return;
      FocusScope.of(context).unfocus();

      setState(() {
        isLoading = true;
      });

      final String email = _email.text.trim();
      final String password = _password.text;

      if (email.isEmpty) {
        showToast(context, 'Enter your email...',
            toastType: ToastificationType.warning,
            iconColor: AppStyles.foregroundColorYellow);
        return;
      } else if (password.isEmpty) {
        showToast(context, 'Enter your password...',
            toastType: ToastificationType.warning,
            iconColor: AppStyles.foregroundColorYellow);
        return;
      }
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Logged user id: ${userCredential.user!.uid}');

      if (!context.mounted) return;
      showToast(
          context,
          title: "Welcome!",
          "You are successfully logged in!",
          toastType: ToastificationType.success,
          iconColor: AppStyles.buttonBgColorGreen,
          toastAlignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 0.0));
      SharedPreferencesHelper.setLoggedIn(true);
      Navigator.pushReplacementNamed(context, './home-view/');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        if (!context.mounted) return;
        showToast(
          context,
          "You have sent too many requests, please check your password and try again...",
        );
      }
      if (e.code == 'invalid-email') {
        if (!context.mounted) return;
        showToast(
          context,
          "Please fill in the correct email...",
        );
      }
      if (e.code == 'invalid-credential') {
        if (!context.mounted) return;
        showToast(
          context,
          "Please enter the correct password...",
        );
      }
      if (e.code == 'user-not-found') {
        if (!context.mounted) return;
        showToast(context, 'User not found...');
      } else if (e.code == 'wrong-password') {
        if (!context.mounted) return;
        showToast(
          context,
          "Your password is incorrect, please try again...",
        );
      } else if (e.code == 'network-request-failed') {
        if (!context.mounted) return;
        showToast(
          context,
          "You do not have the correct network connection...",
        );
      } else if (e.code == 'email-already-in-use') {
        if (!context.mounted) return;
        showToast(
          context,
          'This email address is already in use by another account...',
        );
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        if (!context.mounted) return;
        showToast(context, "Incorrect email or password...");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColorBlack,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
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
                  height: 43,
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _email,
                    style:
                        const TextStyle(color: AppStyles.backgroundColorWhite),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: AppStyles.backgroundColorWhite),
                      hintText: "email",
                      fillColor: AppStyles.primaryBgColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 43,
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    obscureText: _obscureText,
                    controller: _password,
                    style:
                        const TextStyle(color: AppStyles.backgroundColorWhite),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                          color: Colors.white,
                        ),
                      ),
                      suffixIconColor: AppStyles.backgroundColorWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: AppStyles.backgroundColorWhite),
                      hintText: "password",
                      fillColor: AppStyles.primaryBgColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 43,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                                AppStyles.buttonBgColorGreen),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await _signInWithEmailAndPassword();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: AppStyles.backgroundColorWhite,
                                fontSize: 18),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 43,
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
      ),
    );
  }
}
