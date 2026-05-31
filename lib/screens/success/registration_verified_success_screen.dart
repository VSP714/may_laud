import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:may_laud/screens/home/home.dart';
import 'package:may_laud/screens/sign_in/sign_in_screen.dart';

class VerifiedSuccessScreen extends StatelessWidget {
  const VerifiedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          /// TOP LEFT SOFT SHAPE
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

          /// BOTTOM RIGHT SOFT SHAPE
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// SUCCESS ICON (WITH GLOW)
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4C229C), Color(0xFF643EB5)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF643EB5).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.check,
                        size: 60.sp,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    /// TITLE
                    Text(
                      "Verification Successful",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E0C6D),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    /// SUBTEXT
                    Text(
                      "Your phone number has been successfully verified.\nYou can now proceed to use milaud apps.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFF666666),
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 50.h),

                    /// BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WelcomeBackScreen(),
                          ),
                        );
                      },
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
                              color: const Color(0xFF643EB5),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    /// EXTRA SMALL TEXT (OPTIONAL)
                    Text(
                      "Welcome to Milaud • Milaor Camarines Sur",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
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
