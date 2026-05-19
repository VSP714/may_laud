import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Intro page 3
class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TOP IMAGE
          SizedBox(
            height: 0.6.sh, // 60% of screen height
            width: double.infinity,
            child: Stack(
              children: [
                // IMAGE
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/intro_page/intro_page3.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),

                  /// TITLE
                  Text(
                    "Your Milaud\n"
                    "Community Assistant",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C229C),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  /// DESCRIPTION
                  Text(
                    "Access local information, public services,\n"
                    "and community help with just a tap - designed\n"
                    "to make life in Milaor easier.\n",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.6,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// SLOGAN
                  Text(
                    "Oragon kita! Let's build Milaor together.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF6A4BC4),
                      fontWeight: FontWeight.w600,
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
