import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:may_laud/providers/auth_provider.dart';
import 'package:may_laud/screens/sign_in/sign_in_screen.dart';
import 'package:may_laud/screens/sign_up/registration_screen.dart';
import 'package:may_laud/screens/home/main_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ---------------- WELCOME SCREEN ---------------- ///
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  void handleSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeBackScreen()),
    );
  }

  void handleRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  Future<void> handleGuestLogin() async {
    final auth = ref.read(authProvider.notifier);
    await auth.loginAsGuest();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// TOP LEFT SOFT CIRCLE
          Positioned(
            top: -120.h,
            left: -120.w,
            child: Container(
              width: 280.w,
              height: 280.w,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.deepPurpleAccent),
            ),
          ),

          /// BOTTOM RIGHT GLOW
          Positioned(
            bottom: 180.h,
            right: -80.w,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.deepPurpleAccent),
            ),
          ),

          /// BOTTOM WAVES
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 260.h,
              width: double.infinity,
              child: CustomPaint(
                painter: WavePainter(),
              ),
            ),
          ),

          /// MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 28.w,
                vertical: 40.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 25.h),

                  /// Logo
                  Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(),
                    child: Center(
                      child: Image.asset(
                        'assets/images/milaudlogo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 35.h),

                  /// Welcome Title
                  Text(
                    "Welcome to MiLaud",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  /// Subtitle
                  Text(
                    "Please sign in to your account or register\nif you are new to the app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 80.h),

                  /// Sign In Button
                  GestureDetector(
                    onTap: handleSignIn,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7B2CBF),
                            Color(0xFF3A0CA3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B2CBF).withOpacity(0.5),
                            blurRadius: 15.r,
                            offset: Offset(0, 5.h),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  /// Register Button
                  GestureDetector(
                    onTap: handleRegister,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7B2CBF),
                            Color(0xFF3A0CA3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B2CBF).withOpacity(0.5),
                            blurRadius: 15.r,
                            offset: Offset(0, 5.h),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(height: 180.h),

                  /// Footer
                  Text(
                    "By continuing, you agree to our",
                    style: TextStyle(
                      color: const Color(0xFF6A6A8A),
                      fontSize: 12.sp,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          color: const Color(0xFF8A8AC4),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Text(
                        "•",
                        style: TextStyle(
                          color: const Color(0xFF6A6A8A),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: const Color(0xFF8A8AC4),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  Text(
                    "© 2026 MiLaud Municipality. All rights reserved.",
                    style: TextStyle(
                      color: const Color(0xFF6A6A8A),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CUSTOM WAVE PAINTER DESIGN
class WavePainter extends CustomPainter {
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
    path1.moveTo(0, 80);
    path1.quadraticBezierTo(
      size.width * 0.25,
      20,
      size.width * 0.5,
      80,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      140,
      size.width,
      60,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, fillWave);

    final path2 = Path();
    path2.moveTo(0, 100);
    path2.quadraticBezierTo(
      size.width * 0.3,
      40,
      size.width * 0.6,
      120,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      180,
      size.width,
      100,
    );

    canvas.drawPath(path2, lineWave);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
