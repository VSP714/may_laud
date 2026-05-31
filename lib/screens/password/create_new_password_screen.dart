// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../success/password_reset_success_screen.dart';

/// ---------------- NEW PASSWORD CREATION----------------
class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController pass1 = TextEditingController();
  final TextEditingController pass2 = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  String strength = "Weak";
  Color strengthColor = Colors.red;

  String errorText = "";

  void checkStrength(String value) {
    if (value.length < 6) {
      strength = "Weak";
      strengthColor = Colors.red;
    } else if (value.length < 10) {
      strength = "Medium";
      strengthColor = Colors.orange;
    } else {
      strength = "Strong";
      strengthColor = Colors.green;
    }
    setState(() {});
  }

  void validatePasswords() {
    if (pass1.text != pass2.text) {
      errorText = "Passwords do not match";
    } else {
      errorText = "";
    }
    setState(() {});
  }

  void handleSubmit() {
    validatePasswords();

    if (errorText.isEmpty && pass1.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SuccessScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          /// TOP LEFT SOFT CIRCLE
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

          /// BOTTOM RIGHT GLOW
          Positioned(
            bottom: 180.h,
            right: -80.w,
            child: Container(
              width: 180.w,
              height: 180.w,
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

                  /// TITLE
                  Text(
                    "Create New",
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E0C6D),
                    ),
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF5E35B1),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  /// SUBTEXT
                  Text(
                    "Your new password must be different from previous.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 25.h),

                  /// NEW PASSWORD FIELD
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "New Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF555555),
                        fontSize: 14.sp,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create a strong password with at least 8 characters",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
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
                            controller: pass1,
                            obscureText: obscure1,
                            onChanged: (val) {
                              checkStrength(val);
                              validatePasswords();
                            },
                            decoration: InputDecoration(
                              hintText: "Enter new password",
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: const Color(0xFFAAAAAA)),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            obscure1 ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF666666),
                          ),
                          onPressed: () => setState(() => obscure1 = !obscure1),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),

                  /// STRENGTH INDICATOR
                  Row(
                    children: [
                      Text(
                        "Strength: ",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      Text(
                        strength,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: strengthColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  /// CONFIRM PASSWORD FIELD
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF555555),
                        fontSize: 14.sp,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Re‑enter your password to confirm",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
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
                            controller: pass2,
                            obscureText: obscure2,
                            onChanged: (val) => validatePasswords(),
                            decoration: InputDecoration(
                              hintText: "Confirm password",
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: const Color(0xFFAAAAAA)),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            obscure2 ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF666666),
                          ),
                          onPressed: () => setState(() => obscure2 = !obscure2),
                        ),
                      ],
                    ),
                  ),

                  /// ERROR MESSAGE
                  if (errorText.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        errorText,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),

                  SizedBox(height: 20.h),

                  /// RESET PASSWORD BUTTON
                  GestureDetector(
                    onTap: handleSubmit,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
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
                          "Reset Password",
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
