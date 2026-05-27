// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:may_laud/screens/otp_verification/forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  SupabaseClient get _client => Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email address.');
      return;
    }

    // Basic email format check
    final emailRegex = RegExp(r'^[\w\.\+\-]+@[\w\-]+(\.[\w\-]+)+$',
        caseSensitive: false);
    if (!emailRegex.hasMatch(email)) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      await _client.auth.resetPasswordForEmail(email);

      if (!mounted) return;

      // Navigate to OTP screen, passing the email
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(email: email),
        ),
      );
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Something went wrong. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// TOP LEFT SHAPE
          Positioned(
            top: -120.h,
            left: -120.w,
            child: Container(
              width: 280.w,
              height: 280.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF3E5F5).withOpacity(0.6),
              ),
            ),
          ),

          /// BOTTOM RIGHT SHAPE
          Positioned(
            bottom: 150.h,
            right: -80.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE1D5F5).withOpacity(0.5),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),

                  /// BACK BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Color(0xFF5E35B1)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// ICON
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4C229C), Color(0xFF643EB5)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF643EB5).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      color: Colors.white,
                      size: 40.sp,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  /// TITLE
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E0C6D),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  /// SUBTITLE
                  Text(
                    "Enter your registered email address and\n"
                    "we'll send you a verification code to\n"
                    "reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 35.h),

                  /// INPUT LABEL
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF555555),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  /// EMAIL FIELD
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: _errorMessage != null
                            ? Colors.red.shade300
                            : const Color(0xFFDDDDDD),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: const Color(0xFF9E9E9E),
                          size: 22.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            onChanged: (_) =>
                                setState(() => _errorMessage = null),
                            decoration: InputDecoration(
                              hintText: 'yourname@email.com',
                              border: InputBorder.none,
                              hintStyle:
                                  const TextStyle(color: Color(0xFFAAAAAA)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Error message
                  if (_errorMessage != null) ...[
                    SizedBox(height: 10.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 35.h),

                  /// SEND RESET CODE BUTTON
                  GestureDetector(
                    onTap: _isLoading ? null : _sendResetCode,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.r),
                        gradient: LinearGradient(
                          colors: _isLoading
                              ? [Colors.grey.shade400, Colors.grey.shade500]
                              : const [Color(0xFF4C229C), Color(0xFF643EB5)],
                        ),
                        boxShadow: _isLoading
                            ? []
                            : [
                                BoxShadow(
                                  color: const Color(0xFF643EB5),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Send Reset Code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}