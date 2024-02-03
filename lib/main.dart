import 'package:blacknote/firebase_options.dart';
import 'package:blacknote/state/shared_preferences.dart';
import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/views/search_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './views/register_view.dart';
import './views/login_view.dart';
import './views/home_view.dart';
import './views/create_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await SharedPreferencesHelper.isLoggedIn();
  print(isLoggedIn);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            scaffoldBackgroundColor: AppStyles.bgColorBlack,
            textTheme: GoogleFonts.nunitoTextTheme(),
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppStyles.primaryBgColor,
              primary: AppStyles.buttonBgColorGreen,
            ),
            useMaterial3: true,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
                shadowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
              ),
            )),
        home: isLoggedIn ? const HomeView() : const LoginView(),
        routes: {
          './login/': (context) => const LoginView(),
          './register/': (context) => const RegisterView(),
          './home-view/': (context) => const HomeView(),
          './create-view/': (context) => const CreateView(),
        });
  }
}
