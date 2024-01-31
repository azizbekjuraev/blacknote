import 'package:blacknote/style/app_styles.dart';
import 'package:blacknote/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './views/register_view.dart';
import './views/login_view.dart';
import './views/home_view.dart';
import './views/create_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: AppStyles.primaryBgColor,
          textTheme: GoogleFonts.nunitoTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginView(),
        routes: {
          './login/': (context) => const LoginView(),
          './register/': (context) => const RegisterView(),
        });
  }
}
