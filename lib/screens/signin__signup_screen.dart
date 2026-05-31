import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:may_laud/providers/auth_provider.dart';
import 'package:may_laud/screens/sign_in/sign_in_screen.dart';
import 'package:may_laud/screens/sign_up/registration_screen.dart';
import 'package:may_laud/screens/home/nav_bar_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    // Same adaptive palette as sign-in & register screens
    final scaffoldBg = isDark ? cs.background : Colors.white;
    final bubbleBg1 =
        isDark ? cs.primary.withOpacity(0.12) : const Color(0xFFEDE7F6);
    final bubbleBg2Gradient = isDark
        ? [cs.primary.withOpacity(0.10), Colors.transparent]
        : [const Color(0xFFD1C4E9).withOpacity(0.35), Colors.transparent];
    final bubbleBg3Gradient = isDark
        ? [cs.primary.withOpacity(0.12), Colors.transparent]
        : [const Color(0xFFD1C4E9).withOpacity(0.4), Colors.transparent];
    final titleColor =
        isDark ? cs.onBackground : const Color(0xFF2E0C6D);
    final subtitleColor = isDark
        ? cs.onBackground.withOpacity(0.6)
        : const Color(0xFF6E6A75);
    final formBg = isDark ? cs.surface : const Color(0xFFF6F2FC);
    final guestBg = isDark ? cs.surface : Colors.white;
    final guestText = isDark ? cs.primary : Colors.deepPurple;
    final footerColor = isDark
        ? cs.onBackground.withOpacity(0.45)
        : const Color(0xFF6A6A8A);
    final footerLinkColor = isDark
        ? cs.primary.withOpacity(0.8)
        : const Color(0xFF8A8AC4);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // Background decorations — identical to sign-in
          Positioned(
            top: -120.h,
            left: -120.w,
            child: Container(
              width: 280.w,
              height: 280.w,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: bubbleBg1),
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
                gradient: RadialGradient(colors: bubbleBg2Gradient),
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
                gradient: RadialGradient(colors: bubbleBg3Gradient),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 240.h,
              width: double.infinity,
              child: CustomPaint(
                painter: _WavePainter(isDark: isDark, cs: cs),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),

                  // Logo with glow shadow
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF7B2CBF).withOpacity(0.18),
                          blurRadius: 25.r,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/milaudlogo.png',
                      height: 100.h,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  Text(
                    "Welcome to MiLaud",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    "Sign in to your account or create a new one.",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14.sp, color: subtitleColor),
                  ),

                  SizedBox(height: 30.h),

                  // Buttons card — same formBg card as sign-in
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: formBg,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B2CBF)
                              .withOpacity(isDark ? 0.05 : 0.08),
                          blurRadius: 20.r,
                          offset: Offset(0, 8.h),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Sign In button
                        GestureDetector(
                          onTap: handleSignIn,
                          child: Container(
                            width: double.infinity,
                            padding:
                                EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF4C229C),
                                  Color(0xFF643EB5),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4C229C)
                                      .withOpacity(0.3),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Register button — outline style to differentiate
                        GestureDetector(
                          onTap: handleRegister,
                          child: Container(
                            width: double.infinity,
                            padding:
                                EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r),
                              color: guestBg,
                              border: Border.all(
                                color: isDark
                                    ? cs.primary.withOpacity(0.4)
                                    : const Color(0xFF4C229C)
                                        .withOpacity(0.35),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4C229C)
                                      .withOpacity(
                                          isDark ? 0.08 : 0.10),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                  color: guestText,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Footer
                  Text(
                    "By continuing, you agree to our",
                    style:
                        TextStyle(color: footerColor, fontSize: 12.sp),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          color: footerLinkColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text("•",
                          style: TextStyle(
                              color: footerColor, fontSize: 12.sp)),
                      SizedBox(width: 12.w),
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: footerLinkColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "© 2026 MiLaud Municipality. All rights reserved.",
                    style:
                        TextStyle(color: footerColor, fontSize: 12.sp),
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

class _WavePainter extends CustomPainter {
  final bool isDark;
  final ColorScheme cs;

  _WavePainter({required this.isDark, required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final fillColor =
        isDark ? cs.primary.withOpacity(0.08) : const Color(0xFFF3F0FA);
    final strokeColor =
        isDark ? cs.primary.withOpacity(0.25) : const Color(0xFFB39DDB);

    final fillWave = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final lineWave = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path1 = Path();
    path1.moveTo(0, 70);
    path1.quadraticBezierTo(
        size.width * 0.25, 20, size.width * 0.5, 90);
    path1.quadraticBezierTo(
        size.width * 0.75, 150, size.width, 70);
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, fillWave);

    final path2 = Path();
    path2.moveTo(0, 90);
    path2.quadraticBezierTo(
        size.width * 0.3, 40, size.width * 0.6, 110);
    path2.quadraticBezierTo(
        size.width * 0.85, 170, size.width, 100);

    canvas.drawPath(path2, lineWave);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}