import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_day_app/providers/auth_provider.dart';
import 'package:my_day_app/utils/page_navigation_routes.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInScreenMainBlock();
  }
}

class SignInScreenMainBlock extends StatefulWidget {
  const SignInScreenMainBlock({super.key});

  @override
  State<SignInScreenMainBlock> createState() => _SignInScreenMainBlockState();
}

class _SignInScreenMainBlockState extends State<SignInScreenMainBlock>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _regFormKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 40),
                            _buildTabBar(),
                            const SizedBox(height: 32),
                            Expanded(child: _buildTabContent()),
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

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Welcome to onboard !',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6C6767),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Lets help to meet up your tasks.',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 16,
            color: const Color(0xFF6C6767),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x80FFFFFF).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Color(0xFFA2AF9B),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6C6767),
        labelStyle: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Login'),
          Tab(text: 'Register'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 600,
      child: ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: TabBarView(
          controller: _tabController,
          children: [_buildSignInForm(), _buildRegisterForm()],
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: 'Email ID',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validatorType: "email",
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: 'Password',
            controller: _passwordController,
            isPassword: true,
            validatorType: "password",
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  PageNavigationRoutes.forgotPasswordScreen,
                );
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF6C6767),
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return CustomButton(
                text: "Login",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final result = await auth.login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    if (!context.mounted) return;

                    if (result) {
                      log('Logged in successfully...!!',name: 'Logged Result : ');
                      Navigator.pushNamed(
                        context,
                        PageNavigationRoutes.homeScreen,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            auth.error.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              if (context.mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar();
                              }
                            },
                          ),
                        ),
                      );
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _regFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: "Name",
            controller: _nameController,
            validatorType: "name",
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: 'Email ID',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validatorType: "email",
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.number,
            validatorType: "Phone Number",
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: 'Password',
            controller: _passwordController,
            isPassword: true,
            validatorType: "password",
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: 'Re-Enter Password',
            controller: _confirmPasswordController,
            isPassword: true,
            validatorType: "confirm",
            compareWith: _passwordController,
          ),
          const SizedBox(height: 32),

          Consumer<AuthProvider>(
            builder: (context, authObj, child) {
              return CustomButton(
                text: "Register",
                onPressed: () async {
                  if (_regFormKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registering...')),
                    );

                    final result = await authObj.signUp(
                      email: _emailController.text,
                      password: _confirmPasswordController.text,
                      userName: _nameController.text,
                      phone: _phoneController.text,
                    );

                    if (!context.mounted) return;

                    if (result) {
                      log('Registration Successfully completed',name: 'Registration Result :');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration Successfully completed'),
                          backgroundColor: Colors.green, // Set the background color to green
                          duration: Duration(seconds: 1), // Optional: set how long it is visible
                        ),
                      );
                      _tabController.animateTo(0);

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            authObj.error.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              if (context.mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar();
                              }
                            },
                          ),
                        ),
                      );
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
// Widget _buildRegisterForm() {
//   return Form(
//     key: _regFormKey,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         CustomTextField(
//           label: "Name",
//           controller: _nameController,
//           validatorType: "name",
//         ),
//         const SizedBox(height: 20),
//
//         CustomTextField(
//           label: 'Email ID',
//           controller: _emailController,
//           keyboardType: TextInputType.emailAddress,
//           validatorType: "email",
//         ),
//         const SizedBox(height: 20),
//
//         CustomTextField(
//           label: 'Password',
//           controller: _passwordController,
//           isPassword: true,
//           validatorType: "password",
//         ),
//         const SizedBox(height: 20),
//
//         CustomTextField(
//           label: 'Re-Enter Password',
//           controller: _confirmPasswordController,
//           isPassword: true,
//           validatorType: "confirm",
//         ),
//         const SizedBox(height: 32),
//         CustomButton(
//           text: "Register",
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(const SnackBar(content: Text('Registering...')));
//             }
//           },
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildTextField({
//   required String label,
//   required TextEditingController controller,
//   TextInputType? keyboardType,
//   bool isPassword = false,
//   bool isPasswordVisible = false,
//   VoidCallback? onTogglePassword,
//   String? Function(String?)? validator,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: GoogleFonts.openSans(
//           fontSize: 14,
//           color: const Color(0xFF6C6767),
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       const SizedBox(height: 8),
//       TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         obscureText: isPassword && !isPasswordVisible,
//         validator: validator,
//         style: GoogleFonts.openSans(color: const Color(0xFF6C6767)),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Color(0x80FFFFFF).withValues(alpha: 0.2),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide(
//               color: const Color(0xFF6C6767).withValues(alpha: 0.3),
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide(
//               color: const Color(0xFF6C6767).withValues(alpha: 0.3),
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: const BorderSide(color: Color(0xFFA2AF9B), width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: const BorderSide(color: Colors.red),
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 24,
//             vertical: 14,
//             // vertical: 16,
//           ),
//           suffixIcon: isPassword
//               ? IconButton(
//                   icon: Icon(
//                     isPasswordVisible
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     color: const Color(0xFF6C6767),
//                   ),
//                   onPressed: onTogglePassword,
//                 )
//               : null,
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildButton(String text, VoidCallback onPressed) {
//   return SizedBox(
//     height: 56,
//     child: ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFFA2AF9B),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//       ),
//       child: Text(
//         text,
//         style: GoogleFonts.openSans(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     ),
//   );
// }
