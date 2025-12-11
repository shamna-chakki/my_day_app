import 'package:flutter/material.dart';

import '../../../utils/page_navigation_routes.dart';
import '../sign_in/sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // ← uses theme background
        elevation: 0, // ← removes shadow
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black54,
            size: 30,
          ),
          onPressed: () {
            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   PageNavigationRoutes.signInScreen,
            //       (route) => false, // Removes ALL previous routes
            // );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => SignInScreen()),
                  (route) => false,
            );

          },
        ),
      ),
      body: const Column(
        children: [
          Text('welcome home'),
        ],
      ),
    );
  }
}
