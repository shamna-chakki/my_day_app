import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../sign_in/sign_in_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainBlock();
  }
}

class MainBlock extends StatefulWidget {
  const MainBlock({super.key});

  @override
  State<MainBlock> createState() => _MainBlockState();
}

class _MainBlockState extends State<MainBlock> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Gets things with TODOs',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
      icon: Icons.task_alt,
      color: Color(0xFF6B9AAA),
    ),
    OnboardingData(
      title: 'Stay Organized',
      description:
          'Keep track of all your tasks in one place. Never forget an important deadline again.',
      icon: Icons.calendar_today,
      color: Color(0xFF7BA591),
    ),
    OnboardingData(
      title: 'Boost Productivity',
      description:
          'Complete more tasks efficiently with smart reminders and organized workflows.',
      icon: Icons.trending_up,
      color: Color(0xFF8B7AA5),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _fadeController.reset();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CHANGE 1: Removed backgroundColor to use theme's scaffoldBackgroundColor (0xFFFAF9EE)
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  _buildPageIndicator(),
                  const SizedBox(height: 32),
                  _buildButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return FadeTransition(
      opacity: _fadeController,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _scaleController,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: _buildIllustration(data),
            ),
            const SizedBox(height: 48),
            Text(
              data.title,
              textAlign: TextAlign.center,
              style:  GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C6767), // CHANGE 2: Updated to 6C6767
              ),
            ),
            const SizedBox(height: 20),
            Text(
              data.description,
              textAlign: TextAlign.center,
              style:  GoogleFonts.openSans(
                fontSize: 16,
                color: Color(0xFF6C6767), // CHANGE 3: Updated to 6C6767
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(OnboardingData data) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA2AF9B).withValues(alpha: 0.2),
            // color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFA2AF9B).withValues(alpha: 0.2),
                // color: data.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Container(
              // this container is icon's circle.
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFFA2AF9B),
                // color: data.color,
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, size: 60, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: Container(
              // this container is left square in the box
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9EE),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 40,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFA2AF9B), width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(
                    0xFFA2AF9B,
                  ) // CHANGE 4: Updated active indicator to match button color
                : const Color(0xFFD0D0D0),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (_currentPage < _pages.length - 1) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen(),)
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA2AF9B),
          // CHANGE 5: Updated to A2AF9B
          foregroundColor: Colors.white,
          // CHANGE 6: Explicitly set to white (already was white)
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
          style:  GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white, // CHANGE 7: Explicitly set text color to white
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
