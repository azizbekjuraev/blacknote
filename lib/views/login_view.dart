import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/utils/alert_dialogue.dart';
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
      setState(() {
        isLoading = true;
      });

      final String email = _email.text.trim();
      final String password = _password.text;

      if (email.isEmpty) {
        showAlertDialog(context, 'Elektron pochtangizni kiriting...',
            toastType: ToastificationType.warning);
        return;
      } else if (password.isEmpty) {
        showAlertDialog(context, 'Parolingizni kiriting....',
            toastType: ToastificationType.warning);
        return;
      }
      // Move the actual sign-in code inside the try block
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // UserData.setEmail(email);

      // on success
      if (!context.mounted) return;
      showAlertDialog(
          context,
          title: "Xush kelibsiz!",
          "Tizimga admin bo'lib kirdingiz...",
          toastType: ToastificationType.success,
          toastAlignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 35.0));

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthExceptions
      if (e.code == 'too-many-requests') {
        if (!context.mounted) return;
        showAlertDialog(
          context,
          "Juda koʻp so'rovlar yubordingiz, parolni tekshirib, qaytadan urinib ko'ring...",
        );
      }
      if (e.code == 'invalid-email') {
        if (!context.mounted) return;
        showAlertDialog(
          context,
          "Iltimos, elektron pochtani to'g'ri to'ldiring...",
        );
      }
      if (e.code == 'invalid-credential') {
        if (!context.mounted) return;
        showAlertDialog(
          context,
          "Parolni to'g'ri to'ldiring...",
        );
      }
      if (e.code == 'user-not-found') {
        if (!context.mounted) return;
        showAlertDialog(context, 'Foydalanuvchi topilmadi...');
      } else if (e.code == 'wrong-password') {
        if (!context.mounted) return;
        showAlertDialog(
          context,
          "Parolingiz noto'g'ri, qayta urinib ko'ring...",
        );
      } else if (e.code == 'network-request-failed') {
        if (!context.mounted) return;
        showAlertDialog(
          context,
          "Sizda to'g'ri tarmoq ulanishi yo'q...",
        );
      } else if (e.code == 'email-already-in-use') {
        if (!context.mounted) return;
        showAlertDialog(
          context,
          'Bu E-pochta manzili allaqachon boshqa hisobda ishlatilmoqda...',
        );
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        if (!context.mounted) return;
        showAlertDialog(
            context, "Elektron pochta yoki parol noto'g'ri kiritildi...");
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
                height: 43,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _password,
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
                height: 43,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(
                        AppStyles.buttonBgColorGreen),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        color: AppStyles.backgroundColorWhite, fontSize: 18),
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
    );
  }
}
