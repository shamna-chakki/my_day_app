import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_day_app/ui/screens/forgot_password/forgot_password_screen.dart';
import 'package:my_day_app/ui/screens/home/home_screen.dart';
import 'package:my_day_app/ui/screens/main_tab/main_tab_screen.dart';
import 'package:my_day_app/ui/screens/not_found/not_found_screen.dart';
import 'package:my_day_app/ui/screens/onboarding/onboarding_screen.dart';
import 'package:my_day_app/ui/screens/sign_in/sign_in_screen.dart';
import 'package:my_day_app/ui/screens/splash_screen.dart';
import 'package:my_day_app/utils/page_navigation_routes.dart';

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

      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case PageNavigationRoutes.splash:
            return MaterialPageRoute(builder: (_) => SplashScreen());

          case PageNavigationRoutes.onBoardingScreen:
            return MaterialPageRoute(
              builder: (_) => OnboardingScreen(),
            );

          case PageNavigationRoutes.signInScreen:
            return MaterialPageRoute(
              builder: (_) => SignInScreen(),
            );

          case PageNavigationRoutes.forgotPasswordScreen:
            return MaterialPageRoute(
              builder: (_) => ForgotPasswordScreen(),
            );

          case PageNavigationRoutes.homeScreen:
            return MaterialPageRoute(
              builder: (_) => MainTabScreen(initialIndex: 0),
            );

          default:
            return MaterialPageRoute(builder: (_) =>NotFoundScreen());
        }
      },

      home: const SplashScreen(),
    );
  }
}


