import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:may_laud/screens/home/main_app.dart';
// import 'package:may_laud/screens/sign_in/sign_in_screen.dart';
import '../success/registration_verified_success_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  int secondsRemaining = 59;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    // Auto-focus first OTP box
    Future.delayed(const Duration(milliseconds: 300), () {
      if (focusNodes.isNotEmpty) {
        focusNodes[0].requestFocus();
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void _resendCode() {
    if (secondsRemaining == 0) {
      setState(() {
        secondsRemaining = 59;
      });
      startTimer();
      // Show a snackbar or toast (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code resent'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Widget otpBox(int index) {
    return Container(
      width: 60.w,
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: focusNodes[index].hasFocus
              ? const Color(0xFF6A4FB6)
              : const Color(0xFFE0E0E0),
          width: focusNodes[index].hasFocus ? 2 : 1,
        ),
        boxShadow: focusNodes[index].hasFocus
            ? [
                BoxShadow(
                  color: const Color(0xFF6A4FB6).withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        style: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) => _onOtpChanged(value, index),
      ),
    );
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

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),

                    /// Back + Title
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Color(0xFF6A4FB6)),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Text(
                          "Verification",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6A4FB6),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 48.h),

                    /// Icon
                    Icon(
                      Icons.lock_open_outlined,
                      size: 80.w,
                      color: const Color(0xFF6A4FB6).withAlpha(230),
                    ),

                    SizedBox(height: 32.h),

                    /// Title
                    Text(
                      "Enter Verification Code",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    /// Subtitle
                    Text(
                      "We've sent a 6‑digit code to your\n"
                      "phone number for security verification.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xFF666666),
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 45.h),

                    /// OTP Fields
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, otpBox),
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A4FB6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          String code = controllers.map((e) => e.text).join();

                          if (code.length == 6) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VerifiedSuccessScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Please enter complete 6‑digit code"),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Verify",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Resend Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code?",
                          style: TextStyle(
                            color: const Color(0xFF6E6A75),
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        secondsRemaining > 0
                            ? Text(
                                "Resend in 00:${secondsRemaining.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                  color: const Color(0xFF6A4FB6),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.sp,
                                ),
                              )
                            : TextButton(
                                onPressed: _resendCode,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Resend now",
                                  style: TextStyle(
                                    color: const Color(0xFF6A4FB6),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Security note
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 16.w,
                            color: const Color(0xFF6A4FB6).withOpacity(0.6),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "End‑to‑end encrypted",
                            style: TextStyle(
                              color: const Color(0xFF6A4FB6).withOpacity(0.6),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
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
          ),
        ],
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
