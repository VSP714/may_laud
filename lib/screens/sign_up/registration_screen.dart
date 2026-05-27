// lib/screens/sign_up/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:may_laud/providers/auth_provider.dart';
import 'package:may_laud/screens/home/nav_bar_button.dart';
import 'package:may_laud/screens/otp_verification/registration_otp_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedBarangay;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final List<String> _barangays = [
    "San Roque", "Del Rosario", "San Jose", "Amparado", "Lipot",
    "Borongborongan", "San Antonio", "Capucnasan", "Sto Dominggo"
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Validation
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _selectedBarangay == null ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.register(
      name: '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      address: _selectedBarangay!,
    );

    if (mounted) {
      final authState = ref.read(authProvider);
      if (authState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.error!), backgroundColor: Colors.red),
        );
      } else {
        // Supabase sends a confirmation email — navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationScreen(
              email: _emailController.text.trim(),
            ),
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Column(
          children: [
            Icon(Icons.check_circle, size: 60.sp, color: Colors.green),
            SizedBox(height: 12.h),
            Text(
              'Registration Successful!',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Welcome to Milaud, ${_firstNameController.text.trim()}! 🎉\n\nYour account has been created. You can now log in and explore the services.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainApp()),
              );
            },
            child: Text('Continue', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showBarangayPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 12.h,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 30.w),
                      Text(
                        "Select Barangay",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6A1B9A),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Icon(Icons.close, color: const Color(0xFF6A1B9A)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 300.h,
                    child: ListView.builder(
                      itemCount: _barangays.length,
                      itemBuilder: (context, index) {
                        final item = _barangays[index];
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _selectedBarangay = item;
                            });
                            Navigator.pop(ctx);
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: _selectedBarangay == item
                                  ? const Color(0xFFF3E5F5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: _selectedBarangay == item
                                    ? const Color(0xFF6A1B9A)
                                    : const Color(0xFFE0E0E0),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: _selectedBarangay == item
                                        ? const Color(0xFF6A1B9A)
                                        : Colors.black87,
                                  ),
                                ),
                                Icon(
                                  _selectedBarangay == item
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: _selectedBarangay == item
                                      ? const Color(0xFF6A1B9A)
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF3E5F5).withValues(alpha: 0.6),
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
                color: const Color(0xFFE1D5F5).withValues(alpha: 0.5),
              ),
            ),
          ),

          // Main scrollable content (no back button)
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h), // Normal top spacing
                  Text(
                    "Let's",
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E0C6D),
                    ),
                  ),
                  Text(
                    "Register your account",
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF5E35B1),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "Please provide your details below to create your account and get started.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // First & Last Name
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_firstNameController, "First Name", Icons.person_outline)),
                      SizedBox(width: 15.w),
                      Expanded(child: _buildTextField(_lastNameController, "Last Name", Icons.person_outline)),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Email field
                  _buildTextField(_emailController, "Email", Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 20.h),

                  // Phone field
                  _buildPhoneField(),
                  SizedBox(height: 20.h),

                  // Barangay field
                  _buildBarangayField(),
                  SizedBox(height: 20.h),

                  // Password field
                  _buildPasswordField(),
                  SizedBox(height: 20.h),

                  // Confirm Password field
                  _buildConfirmPasswordField(),
                  SizedBox(height: 30.h),

                  if (authState.isLoading)
                    const CircularProgressIndicator()
                  else
                    GestureDetector(
                      onTap: _register,
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
                              color: const Color(0xFF643EB5).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Register now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
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
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xFF555555))),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF666666)),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Phone Number", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xFF555555))),
        SizedBox(height: 6.h),
        Text("We'll use this for verification and important updates",
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Text("🇵🇭", style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 6.w),
                    Text("+63", style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xFF333333))),
                    SizedBox(width: 4.w),
                    Icon(Icons.keyboard_arrow_down, size: 18.sp, color: const Color(0xFF666666)),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(width: 1.w, height: 24.h, color: Colors.grey.shade300),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "Enter your phone number",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBarangayField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Barangay", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xFF555555))),
        SizedBox(height: 6.h),
        Text("Select your barangay to locate your area",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF888888))),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: _showBarangayPicker,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: const Color(0xFF666666)),
                    SizedBox(width: 12.w),
                    Text(
                      _selectedBarangay ?? "Select your barangay",
                      style: TextStyle(
                        color: _selectedBarangay == null ? const Color(0xFFAAAAAA) : const Color(0xFF333333),
                        fontWeight: _selectedBarangay == null ? FontWeight.normal : FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_drop_down, color: const Color(0xFF666666)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xFF555555))),
        SizedBox(height: 6.h),
        Text("Create a strong password with at least 8 characters, numbers, and letters",
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
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xFF555555))),
        SizedBox(height: 6.h),
        Text("Re-enter your password to confirm",
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
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  decoration: const InputDecoration(
                    hintText: "Confirm your password",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF666666)),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ],
          ),
        ),
      ],
    );
  }
}