import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_day_app/providers/auth_provider.dart';
import 'package:my_day_app/ui/widgets/custom_text_field.dart';
import 'package:my_day_app/utils/page_navigation_routes.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: ForgotSPasswordMainBlock(),
    );
  }
}

class ForgotSPasswordMainBlock extends StatefulWidget {
  const ForgotSPasswordMainBlock({super.key});

  @override
  State<ForgotSPasswordMainBlock> createState() =>
      _ForgotSPasswordMainBlockState();
}

class _ForgotSPasswordMainBlockState extends State<ForgotSPasswordMainBlock> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Controllers
  final _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form keys
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  // State
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  int _remainingTime = 60;
  Timer? _timer;

  String? _generatedOTP;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
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

  // Future<void> _sendOTP() async {
  //   if (!_emailFormKey.currentState!.validate()) return;
  //
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     final isUserExists = await context.read<AuthProvider>().checkUserExists(
  //       email: _emailController.text.trim(),
  //     );
  //
  //     if (!isUserExists) {
  //       _showSnackBar('User not found', isError: true);
  //       return;
  //     }
  //     else{
  //       final random = Random();
  //       _generatedOTP = List.generate(6, (_) => random.nextInt(10)).join();
  //
  //       debugPrint('OTP: $_generatedOTP');
  //
  //       _startTimer();
  //       _nextStep();
  //
  //     }
  //
  //
  //   } catch (e) {
  //     _showSnackBar(e.toString(), isError: true);
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  // Send OTP to email
  Future<void> _sendOTP() async {
    setState(() => _isLoading = false);
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final Random random = Random();
      String otp = '';
      // Generate random digits and append to the string
      for (int i = 0; i < 6; i++) {
        otp += random.nextInt(10).toString();
      }
      _generatedOTP = otp;

      _showSnackBar('OTP = $_generatedOTP');
      _startTimer();
      _nextStep();
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyOTP() async {
    final enteredOTP = _otpControllers.map((c) => c.text).join();

    if (enteredOTP.length != 6) {
      _showSnackBar('Enter complete OTP', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (enteredOTP == _generatedOTP) {
        _showSnackBar('OTP verified');
        _nextStep();
      } else {
        _showSnackBar('Invalid OTP', isError: true);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Verify OTP
  // Future<void> _verifyOTP() async {
  //   String enteredOTP = _otpControllers.map((c) => c.text).join();
  //
  //   if (enteredOTP.length != 6) {
  //     _showSnackBar('Please enter complete OTP', isError: true);
  //     return;
  //   }
  //
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     if (_generatedOTP == enteredOTP) {
  //       // Temporary simulation - Remove this when OTPService is ready
  //       await Future.delayed(const Duration(seconds: 2));
  //       _showSnackBar('OTP verified successfully!');
  //       _nextStep();
  //     } else {
  //       _showSnackBar('Error: $e', isError: true);
  //     }
  //   } catch (e) {
  //     _showSnackBar('Error: $e', isError: true);
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  // Resend OTP
  Future<void> _resendOTP() async {
    if (_remainingTime > 0) return;

    for (var c in _otpControllers) {
      c.clear();
    }

    await _sendOTP();
  }

  // Future<void> _sendEmail() async {
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     final result = await context.read<AuthProvider>().sendEmail(
  //       _emailController.text,
  //     );
  //     if (result == true) {
  //       _showSnackBar('Please check your mail,', isError: false);
  //
  //     }
  //   } catch (e) {
  //     _showSnackBar(e.toString(), isError: true);
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  Future<void> _sendEmail() async {
    setState(() => _isLoading = true);

    try {
      final result = await context.read<AuthProvider>().sendEmail(
        _emailController.text.trim(),
      );

      if (result == true) {
        _showSnackBar('Please check your mail', isError: false);

        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          Navigator.pushReplacementNamed(
            context,
            PageNavigationRoutes.signInScreen,
          );
        });
      } else {
        _showSnackBar('User not found', isError: true);
      }
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9EE),
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
                    : const Color(0xFFFFFFFF).withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFA2AF9B), width: 2),
              ),
              child: Center(
                child: index < _currentStep
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
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
                    : const Color(0xFFFFFFFF).withValues(alpha: 0.5),
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
            CustomTextField(
              label: 'Enter Email ID',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validatorType: "email",
            ),
            const SizedBox(height: 32),
            _buildButton('Send OTP', _sendOTP),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPStep() {
    return SingleChildScrollView(
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
                'Didn\'t receive code? ',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF6C6767),
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: _remainingTime == 0 && !_isLoading
                    ? _resendOTP
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
          _buildButton('Verify OTP', _verifyOTP),
        ],
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
              'You can change password only through ur email, Please check ur mail after click on Send Mail button',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: const Color(0xFF6C6767),
              ),
            ),

            const SizedBox(height: 32),

            _buildButton('Send Mail', _sendEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(IconData icon) {
    return SizedBox(
      width: 200,
      height: 100,
      child: Center(
        child: Icon(icon, size: 80, color: const Color(0xFFA2AF9B)),
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
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
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
              fillColor: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
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
                _otpFocusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _otpFocusNodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
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
          style: GoogleFonts.openSans(color: const Color(0xFF6C6767)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
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
              borderSide: const BorderSide(color: Color(0xFFA2AF9B), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red),
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
        // onPressed: () async {
        //   final result = await context
        //       .read<AuthProvider>()
        //       .sendForgotPasswordEmail(_emailController.text);
        //   if (result == true) {
        //     _showSnackBar('Password reset link sent to your email',isError: false);
        //   }else{
        //     _showSnackBar('User Not Found',isError: true);
        //   }
        // },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA2AF9B),
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: const Color(
            0xFFA2AF9B,
          ).withValues(alpha: 0.5),
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
