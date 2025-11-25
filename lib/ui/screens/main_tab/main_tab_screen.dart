import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:my_day_app/ui/screens/home/home_screen.dart';
// Add more screen imports if needed

class MainTabScreen extends StatefulWidget {
  final int initialIndex;
  final int? id;

  const MainTabScreen({
    super.key,
    required this.initialIndex,
    this.id,
  });

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen>
    with TickerProviderStateMixin {

  late int _currentIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    _screens = [
      const HomeScreen(),
      const Center(child: Text("Search Screen")),
      const Center(child: Text("Profile Screen")),
    ];
  }

  void _onPopInvoked(bool didPop) {
    if (_currentIndex <= 0) {
      SystemNavigator.pop();
    } else {
      setState(() => _currentIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: _onPopInvoked,
      child: Scaffold(
        extendBody: true,

        // ★ Parent-style screen management (keeps state alive)
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),

        // ★ Modern Curved Navigation Bar
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          color: Colors.blueAccent,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 350),

          onTap: (index) {
            setState(() => _currentIndex = index);
          },

          items: const [
            CurvedNavigationBarItem(
              child: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.search, color: Colors.white),
              label: 'Search',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.person, color: Colors.white),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
