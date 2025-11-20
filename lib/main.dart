import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_day_app/ui/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Day App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFAF9EE),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFAF9EE)),
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}


