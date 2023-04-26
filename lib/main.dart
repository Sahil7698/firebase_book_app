import 'dart:async';

import 'package:firebase_book_app/view/screens/add_book_details.dart';
import 'package:firebase_book_app/view/screens/login_page.dart';
import 'package:firebase_book_app/view/screens/registration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      home: const SplashScreen(),
      routes: {
        'login_page': (context) => const LoginPage(),
        'registration_page': (context) => const RegistrationPage(),
        'home_page': (context) => const HomePage(),
      },
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage("assets/images/book.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Book App",
              style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 35),
            ),
          ],
        ),
      ),
    );
  }
}
