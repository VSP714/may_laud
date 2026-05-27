// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:may_laud/providers/auth_provider.dart';
import 'package:may_laud/screens/sign_up/registration_screen.dart';
import 'package:may_laud/screens/password/forgot_password_screen.dart';
import 'package:may_laud/screens/home/nav_bar_button.dart';

class WelcomeBackScreen extends ConsumerStatefulWidget {
  const WelcomeBackScreen({super.key});

  @override
  ConsumerState<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends ConsumerState<WelcomeBackScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.login(_emailController.text.trim(), _passwordController.text);

    if (mounted && ref.read(authProvider).isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            top: -120.h,
            left: -120.w,
            child: Container(
              width: 280.w,
              height: 280.w,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEDE7F6)),
            ),
          ),
          Positioned(
            top: 100.h,
            right: -60.w,
            child: Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xFFD1C4E9).withValues(alpha: 0.35), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 180.h,
            right: -80.w,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xFFD1C4E9).withValues(alpha: 0.4), Colors.transparent],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 240.h,
              width: double.infinity,
              child: CustomPaint(painter: _WavePainter()),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B2CBF).withValues(alpha: 0.18),
                          blurRadius: 25.r,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/milaudlogo.png', height: 100.h),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "Welcome to MiLaud",
                    style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2E0C6D)),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Enter your email and password",
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6E6A75)),
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F2FC),
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B2CBF).withValues(alpha: 0.08),
                          blurRadius: 20.r,
                          offset: Offset(0, 8.h),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email field
                        Text("Email", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xFF555555))),
                        SizedBox(height: 6.h),
                        Text("We'll use this to sign you in",
                            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF888888))),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.email_outlined, color: Color(0xFF666666)),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Enter your email",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Password field
                        Text("Password", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xFF555555))),
                        SizedBox(height: 6.h),
                        Text("Enter your password to access your account",
                            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF888888))),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock_outline, color: Color(0xFF666666)),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: const InputDecoration(
                                    hintText: "Enter your password",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF666666)),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        // Remember me & Forgot password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  activeColor: const Color(0xFF4C229C),
                                  onChanged: (val) => setState(() => _rememberMe = val ?? false),
                                ),
                                Text("Remember me", style: TextStyle(fontSize: 14.sp)),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                                );
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(color: const Color(0xFF4C229C), fontWeight: FontWeight.w600, fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        // Sign in button
                        if (authState.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          GestureDetector(
                            onTap: _login,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.r),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF4C229C), Color(0xFF643EB5)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4C229C).withValues(alpha: 0.3),
                                    blurRadius: 12.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        if (authState.error != null)
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Text(
                              authState.error!,
                              style: TextStyle(color: Colors.red, fontSize: 13.sp),
                            ),
                          ),
                        SizedBox(height: 14.h),
                        // Create account link
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.black54, fontSize: 14.sp),
                                children: [
                                  TextSpan(
                                    text: "Create Account",
                                    style: TextStyle(color: const Color(0xFF4C229C), fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        // Guest button
                        GestureDetector(
                          onTap: () async {
                            final authNotifier = ref.read(authProvider.notifier);
                            await authNotifier.loginAsGuest();
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MainApp()),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4C229C).withValues(alpha: 0.15),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Continue as Guest",
                                style: TextStyle(color: Colors.deepPurple, fontSize: 18.sp, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillWave = Paint()
      ..color = const Color(0xFFF3F0FA)
      ..style = PaintingStyle.fill;

    final lineWave = Paint()
      ..color = const Color(0xFFB39DDB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path1 = Path();
    path1.moveTo(0, 70);
    path1.quadraticBezierTo(
      size.width * 0.25,
      20,
      size.width * 0.5,
      90,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      150,
      size.width,
      70,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, fillWave);

    final path2 = Path();
    path2.moveTo(0, 90);
    path2.quadraticBezierTo(
      size.width * 0.3,
      40,
      size.width * 0.6,
      110,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      170,
      size.width,
      100,
    );

    canvas.drawPath(path2, lineWave);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}