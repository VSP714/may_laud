import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:may_laud/screens/password/forgot_password_screen.dart';
import 'package:may_laud/screens/sign_up/registration_screen.dart';
import 'package:may_laud/screens/home/nav_bar_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({super.key});

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  bool rememberMe = false;
  bool obscure = true;
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
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
                shape: BoxShape.circle,
                color: Color(0xFFEDE7F6),
              ),
            ),
          ),

          /// TOP RIGHT LIGHT GLOW
          Positioned(
            top: 100.h,
            right: -60.w,
            child: Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD1C4E9).withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// BOTTOM RIGHT GLOW
          Positioned(
            bottom: 180.h,
            right: -80.w,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD1C4E9).withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// BOTTOM WAVES
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 240.h,
              width: double.infinity,
              child: CustomPaint(
                painter: MilaudWavePainter(),
              ),
            ),
          ),

          /// MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 30.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),

                  /// LOGO
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B2CBF).withOpacity(0.18),
                          blurRadius: 25.r,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/milaudlogo.png',
                      height: 100.h,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  /// TITLE
                  Text(
                    "Welcome to MiLaud",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E0C6D),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  /// SUBTITLE
                  Text(
                    "Enter your phone number and password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF6E6A75),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  /// FORM CARD
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F2FC),
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B2CBF).withOpacity(0.08),
                          blurRadius: 20.r,
                          offset: Offset(0, 8.h),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// PHONE NUMBER
                        Text(
                          "Phone Number",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF555555),
                            fontSize: 14.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "We'll use this for verification and important updates",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF888888),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFDDDDDD),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    Text("🇵🇭",
                                        style: TextStyle(fontSize: 16.sp)),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "+63",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333)),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(Icons.keyboard_arrow_down,
                                        size: 18.sp, color: Color(0xFF666666)),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Container(
                                  width: 1.w,
                                  height: 24.h,
                                  color: Colors.grey.shade300),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "Enter Phone number",
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Color(0xFFAAAAAA)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// PASSWORD
                        Text(
                          "Password",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF555555),
                            fontSize: 14.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "Enter your password to access your account",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF888888),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFDDDDDD),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock_outline,
                                  color: Color(0xFF666666)),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: TextField(
                                  obscureText: obscure,
                                  decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: const Color(0xFFAAAAAA)),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF666666),
                                ),
                                onPressed: () =>
                                    setState(() => obscure = !obscure),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15.h),

                        /// REMEMBER + FORGOT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  activeColor: const Color(0xFF4C229C),
                                  onChanged: (val) {
                                    setState(() {
                                      rememberMe = val ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  "Remember me",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: const Color(0xFF4C229C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        /// SIGN IN BUTTON
                        _buildPrimaryButton(
                          text: "Sign in",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainApp(),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 14.h),

                        /// CREATE ACCOUNT
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterScreen(),
                              ),
                            );
                          },
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Create Account",
                                    style: TextStyle(
                                      color: const Color(0xFF4C229C),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 40.h),

                        /// GUEST BUTTON
                        _buildSecondaryButton(
                          text: "Continue as User",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainApp(),
                              ),
                            );
                          },
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

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
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
              color: const Color(0xFF4C229C).withOpacity(0.3),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C229C).withOpacity(0.15),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class MilaudWavePainter extends CustomPainter {
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
