// lib/screens/success/registration_verified_success_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:may_laud/screens/sign_in/sign_in_screen.dart';

class VerifiedSuccessScreen extends StatelessWidget {
  const VerifiedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    final scaffoldBg    = isDark ? cs.background : Colors.white;
    final bubbleBg1     = isDark ? cs.primary.withOpacity(0.12) : const Color(0xFFEDE7F6);
    final bubble2Colors = isDark ? [cs.primary.withOpacity(0.10), Colors.transparent] : [const Color(0xFFD1C4E9).withOpacity(0.35), Colors.transparent];
    final bubble3Colors = isDark ? [cs.primary.withOpacity(0.12), Colors.transparent] : [const Color(0xFFD1C4E9).withOpacity(0.4), Colors.transparent];
    final titleColor    = isDark ? cs.onBackground : const Color(0xFF2E0C6D);
    final subtitleColor = isDark ? cs.onBackground.withOpacity(0.6) : const Color(0xFF666666);
    final accentPurple  = isDark ? cs.primary : const Color(0xFF4C229C);
    final footerColor   = isDark ? cs.onBackground.withOpacity(0.35) : Colors.grey;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          Positioned(
            top: -120.h, left: -120.w,
            child: Container(
              width: 280.w, height: 280.w,
              decoration: BoxDecoration(shape: BoxShape.circle, color: bubbleBg1),
            ),
          ),
          Positioned(
            top: 100.h, right: -60.w,
            child: Container(
              width: 160.w, height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: bubble2Colors),
              ),
            ),
          ),
          Positioned(
            bottom: 180.h, right: -80.w,
            child: Container(
              width: 180.w, height: 180.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: bubble3Colors),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 240.h, width: double.infinity,
              child: CustomPaint(painter: _SuccessWavePainter(isDark: isDark, cs: cs)),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h),

                  Container(
                    width: 120.w, height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [accentPurple, const Color(0xFF643EB5)]),
                      boxShadow: [
                        BoxShadow(
                          color: accentPurple.withOpacity(0.4),
                          blurRadius: 20.r,
                          offset: Offset(0, 8.h),
                        ),
                      ],
                    ),
                    child: Icon(Icons.check_rounded, size: 60.sp, color: Colors.white),
                  ),

                  SizedBox(height: 40.h),

                  Text(
                    "Verification Successful",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: titleColor),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    "Your phone number has been successfully verified.\nYou can now proceed to use Milaud apps.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.sp, color: subtitleColor, height: 1.5),
                  ),

                  SizedBox(height: 50.h),

                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeBackScreen()),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.r),
                        gradient: LinearGradient(colors: [accentPurple, const Color(0xFF643EB5)]),
                        boxShadow: [
                          BoxShadow(color: accentPurple.withOpacity(0.35), blurRadius: 12.r, offset: Offset(0, 6.h)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    "Welcome to Milaud • Milaor Camarines Sur",
                    style: TextStyle(fontSize: 12.sp, color: footerColor),
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

class _SuccessWavePainter extends CustomPainter {
  final bool isDark;
  final ColorScheme cs;
  _SuccessWavePainter({required this.isDark, required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final fillColor   = isDark ? cs.primary.withOpacity(0.08) : const Color(0xFFF3F0FA);
    final strokeColor = isDark ? cs.primary.withOpacity(0.25) : const Color(0xFFB39DDB);

    final fillWave = Paint()..color = fillColor..style = PaintingStyle.fill;
    final lineWave = Paint()..color = strokeColor..style = PaintingStyle.stroke..strokeWidth = 2;

    final path1 = Path()
      ..moveTo(0, 70)
      ..quadraticBezierTo(size.width * 0.25, 20, size.width * 0.5, 90)
      ..quadraticBezierTo(size.width * 0.75, 150, size.width, 70)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path1, fillWave);

    final path2 = Path()
      ..moveTo(0, 90)
      ..quadraticBezierTo(size.width * 0.3, 40, size.width * 0.6, 110)
      ..quadraticBezierTo(size.width * 0.85, 170, size.width, 100);
    canvas.drawPath(path2, lineWave);
  }

  @override
  bool shouldRepaint(covariant _SuccessWavePainter old) => old.isDark != isDark;
}