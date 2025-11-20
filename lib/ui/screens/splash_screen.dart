import 'package:flutter/material.dart';
import 'package:my_day_app/utils/app_const.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Image.asset(fit:BoxFit.cover,AppConst.logoImage),
      ),
    );
  }
}
