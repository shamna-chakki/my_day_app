import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;

  /// NEW: choose which validation to apply
  final String? validatorType;

  /// used only when validatorType == "confirm"
  final TextEditingController? compareWith;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.validatorType,
    this.compareWith,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPasswordVisible = false;

  // ---------------------------
  // VALIDATIONS INSIDE WIDGET
  // ---------------------------
  String? _validate(String? value) {
    if (widget.validatorType == "name") {
      if (value == null || value.isEmpty) return "Please enter your name";
    }

    if (widget.validatorType == "email") {
      if (value == null || value.isEmpty) return "Please enter your email";
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return "Please enter a valid email";
      }
    }

    if (widget.validatorType == "password") {
      if (value == null || value.isEmpty) return "Please enter your password";
      if (value.length < 6) {
        return "Password must be at least 6 characters";
      }
    }

    if (widget.validatorType == "confirm") {
      if (value == null || value.isEmpty) {
        return "Please re-enter your password";
      }
      if (widget.compareWith != null &&
          value != widget.compareWith!.text) {
        return "Passwords do not match";
      }
    }


    return null; // valid
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: const Color(0xFF6C6767),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword && !isPasswordVisible,
          validator: _validate,

          style: GoogleFonts.openSans(
            color: const Color(0xFF6C6767),
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0x80FFFFFF).withValues(alpha: 0.2),

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

            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF6C6767),
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }
}
