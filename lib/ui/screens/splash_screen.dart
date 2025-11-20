import 'package:flutter/material.dart';
import 'package:my_day_app/ui/screens/onboarding/onboarding_screen.dart';
import 'package:my_day_app/utils/app_const.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => navigate(context));
    return Scaffold(
      body:Center(
        child: Image.asset(fit:BoxFit.cover,AppConst.logoImage),
      ),
    );
  }

  Future<void> navigate(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    if (!context.mounted) {
      return;
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
            (route) => false,
      );
    }
  }
}
