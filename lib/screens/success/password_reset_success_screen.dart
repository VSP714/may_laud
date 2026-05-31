// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:may_laud/screens/sign_in/sign_in_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          /// SOFT BACKGROUND BLOBS (MINIMAL PREMIUM STYLE)
          Positioned(
            top: -100.h,
            left: -80.w,
            child: _blob(const Color(0xFFF3E5F5)),
          ),
          Positioned(
            bottom: -120.h,
            right: -100.w,
            child: _blob(const Color(0xFFE1D5F5)),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// ICON CARD
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4C229C),
                              Color(0xFF643EB5),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF643EB5).withOpacity(0.25),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),

                      SizedBox(height: 35.h),

                      /// TITLE
                      Text(
                        "Success",
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E0C6D),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      /// SUBTITLE
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          "Your password has been updated successfully. You can now use your new password to sign in.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: const Color(0xFF6E6E6E),
                            height: 1.5,
                          ),
                        ),
                      ),

                      SizedBox(height: 50.h),

                      /// BUTTON (PREMIUM STYLE YOU WANTED)
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: Container(
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
                                color: const Color(0xFF643EB5).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WelcomeBackScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Sign in Now",
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// SMALL FOOTNOTE
                      Text(
                        "You will be redirected to the Sign in screen.",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF9A9A9A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BACKGROUND BLOBS
  Widget _blob(Color color) {
    return Container(
      width: 220.w,
      height: 220.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.5),
      ),
    );
  }
}
