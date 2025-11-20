import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_day_app/ui/screens/sign_in/sign_in_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ForgotSPasswordMainBlock();
  }
}

class ForgotSPasswordMainBlock extends StatefulWidget {
  const ForgotSPasswordMainBlock({super.key});

  @override
  State<ForgotSPasswordMainBlock> createState() => _ForgotSPasswordMainBlockState();
}

class _ForgotSPasswordMainBlockState extends State<ForgotSPasswordMainBlock> {

  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Controllers
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form keys
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  // State
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  int _remainingTime = 60;
  Timer? _timer;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: const Color(0xFFFAF9EE),
                  elevation: 0,
                  floating: true,
                  pinned: false,
                  leading: _currentStep > 0
                      ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF6C6767),
                    ),
                    onPressed: () {
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep--;
                        });
                        _pageController.animateToPage(
                          _currentStep,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }

                    },
                  )
                      : null,
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 600 ? 80 : 24,
                    vertical: 24,
                  ),
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStepIndicator(),
                            const SizedBox(height: 40),
                            SizedBox(
                              height: 600,
                              child: PageView(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildEmailStep(),
                                  _buildOTPStep(),
                                  _buildNewPasswordStep(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? const Color(0xFFA2AF9B)
                    : Color(0x80FFFFFF).withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFA2AF9B),
                  width: 2,
                ),
              ),
              child: Center(
                child: index < _currentStep
                    ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                )
                    : Text(
                  '${index + 1}',
                  style: GoogleFonts.openSans(
                    color: index <= _currentStep
                        ? Colors.white
                        : const Color(0xFF6C6767),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (index < 2)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 2,
                color: index < _currentStep
                    ? const Color(0xFFA2AF9B)
                    : Color(0x80FFFFFF).withValues(alpha: 0.5),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildEmailStep() {
    return SingleChildScrollView(
      child: Form(
        key: _emailFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildIllustration(Icons.lock_outline),
            const SizedBox(height: 32),
            Text(
              'Forgot Password?',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6C6767),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Enter your email to receive OTP',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: const Color(0xFF6C6767),
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField(
              label: 'Enter Email ID',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 32),
            _buildButton(
              'Send OTP',
                  () async {
                if (_emailFormKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    _isLoading = false;
                  });
                  _startTimer();
                  _nextStep();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPStep() {
    return SingleChildScrollView(
      child: Form(
        key: _otpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildIllustration(Icons.mail_outline),
            const SizedBox(height: 32),
            Text(
              'Verify OTP',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6C6767),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Enter the 6-digit code sent to\n${_emailController.text}',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: const Color(0xFF6C6767),
              ),
            ),
            const SizedBox(height: 40),
            _buildOTPFields(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Did\'t receive code? ',
                  style: GoogleFonts.openSans(
                    color: const Color(0xFF6C6767),
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: _remainingTime == 0
                      ? () {
                    _startTimer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP Resent!')),
                    );
                  }
                      : null,
                  child: Text(
                    _remainingTime > 0
                        ? 'Resend in ${_remainingTime}s'
                        : 'Resend',
                    style: GoogleFonts.openSans(
                      color: _remainingTime > 0
                          ? const Color(0xFF6C6767).withValues(alpha: 0.5)
                          : const Color(0xFFA2AF9B),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildButton(
              'Verify OTP',
                  () async {
                if (_otpController.text.length == 6) {
                  setState(() {
                    _isLoading = true;
                  });
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    _isLoading = false;
                  });
                  _nextStep();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid OTP')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPasswordStep() {
    return SingleChildScrollView(
      child: Form(
        key: _passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildIllustration(Icons.lock_reset),
            const SizedBox(height: 32),
            Text(
              'Set New Password',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6C6767),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create a strong password',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: const Color(0xFF6C6767),
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField(
              label: 'New Password',
              controller: _newPasswordController,
              isPassword: true,
              isPasswordVisible: _isNewPasswordVisible,
              onTogglePassword: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
              validator: _validatePassword,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              isPassword: true,
              isPasswordVisible: _isConfirmPasswordVisible,
              onTogglePassword: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            _buildButton(
              'Reset Password',
                  () async {
                if (_passwordFormKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen(),));
                  });
                  // await Future.delayed(const Duration(seconds: 2));
                  // setState(() {
                  //   _isLoading = false;
                  // });
                  // if (context.mounted) {
                  //  return;
                  // }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(IconData icon) {
    return SizedBox(
      //replaced container.
      width: 200,
      height: 100,
      // decoration: BoxDecoration(
      //   color: Color(0xFFDCCFC0).withValues(alpha: 0.2),
      //   borderRadius: BorderRadius.circular(24),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Color(0x80FF0000).withValues(alpha: 0.5),
      //       blurRadius: 20,
      //       offset: const Offset(0, 8),
      //     ),
      //   ],
      // ),
      child: Center(
        child: Icon(
          icon,
          size: 80,
          color: const Color(0xFFA2AF9B),
        ),
      ),
    );
  }

  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 50,
          child: TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: GoogleFonts.openSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6C6767),
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Color(0x80FFFFFF).withValues(alpha: 0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF6C6767).withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF6C6767).withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFA2AF9B),
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < 5) {
                FocusScope.of(context).nextFocus();
              }
              _otpController.text = _buildOTPString();
            },
          ),
        );
      }),
    );
  }

  String _buildOTPString() {
    return '111111';
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: const Color(0xFF6C6767),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && !isPasswordVisible,
          validator: validator,
          style: GoogleFonts.openSans(
            color: const Color(0xFF6C6767),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0x80FFFFFF).withValues(alpha: 0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: const Color(0xFF6C6767).withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: const Color(0xFF6C6767).withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xFFA2AF9B),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF6C6767),
              ),
              onPressed: onTogglePassword,
            )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA2AF9B),
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: const Color(0xFFA2AF9B).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          text,
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}




