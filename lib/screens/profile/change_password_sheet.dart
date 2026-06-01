import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/auth_provider.dart';
import '../home/home.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    final titleColor = isDark ? cs.onSurface : HomeColors.deepAnchor;
    // FIX: always use purple, never colorScheme.primary
    const accentColor = HomeColors.heritagePurple;
    final cardColor = isDark ? cs.surface : Colors.white;
    final handleColor = isDark ? cs.onSurface.withOpacity(0.2) : Colors.grey[300]!;
    final subtitleColor = isDark ? cs.onSurface.withOpacity(0.5) : const Color(0xFF9E9E9E);
    final closeIconColor = isDark ? cs.onSurface.withOpacity(0.5) : const Color(0xFF9E9E9E);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              24.w, 20.h, 24.w,
              MediaQuery.of(context).viewInsets.bottom + 28.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: handleColor,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Header row
                  Row(
                    children: [
                      Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.lock_outline,
                            size: 22.sp, color: accentColor),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                              ),
                            ),
                            Text(
                              'Keep your account secure',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 22.sp,
                          color: closeIconColor,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  _passwordField(
                    context: context,
                    isDark: isDark,
                    cs: cs,
                    controller: _currentCtrl,
                    label: 'Current Password',
                    obscure: !_showCurrent,
                    toggle: () =>
                        setState(() => _showCurrent = !_showCurrent),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  SizedBox(height: 14.h),
                  _passwordField(
                    context: context,
                    isDark: isDark,
                    cs: cs,
                    controller: _newCtrl,
                    label: 'New Password',
                    obscure: !_showNew,
                    toggle: () => setState(() => _showNew = !_showNew),
                    validator: (v) => (v == null || v.length < 8)
                        ? 'At least 8 characters'
                        : null,
                  ),
                  SizedBox(height: 14.h),
                  _passwordField(
                    context: context,
                    isDark: isDark,
                    cs: cs,
                    controller: _confirmCtrl,
                    label: 'Confirm New Password',
                    obscure: !_showConfirm,
                    toggle: () =>
                        setState(() => _showConfirm = !_showConfirm),
                    validator: (v) =>
                        v != _newCtrl.text ? 'Passwords do not match' : null,
                  ),

                  SizedBox(height: 28.h),

                  // Buttons row
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDark
                                  ? cs.onSurface.withOpacity(0.7)
                                  : const Color(0xFF757575),
                              side: BorderSide(
                                color: isDark
                                    ? cs.onSurface.withOpacity(0.2)
                                    : Colors.grey[300]!,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            onPressed: _isSaving ? null : _submit,
                            child: _isSaving
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Update',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final email = ref.read(authProvider).user?.email ?? '';
      await ref.read(authProvider.notifier).sendPasswordResetEmail(email);
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Password reset email sent. Check your inbox.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            margin: EdgeInsets.all(12.w),
          ),
        );
      }
    } catch (_) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update password. Try again.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            margin: EdgeInsets.all(12.w),
          ),
        );
      }
    }
  }

  Widget _passwordField({
    required BuildContext context,
    required bool isDark,
    required ColorScheme cs,
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    const accentColor = HomeColors.heritagePurple;
    final fillColor = isDark ? cs.surface.withOpacity(0.6) : Colors.grey[50]!;
    final borderColor = isDark ? cs.onSurface.withOpacity(0.15) : Colors.grey[300]!;
    final iconColor = isDark ? cs.onSurface.withOpacity(0.4) : const Color(0xFF9E9E9E);

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(color: isDark ? cs.onSurface : null),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock_outline,
            color: accentColor, size: 20.sp),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            size: 20.sp,
            color: iconColor,
          ),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: accentColor, width: 1.5),
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding:
            EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      ),
    );
  }
}

/// Call this instead of the old showChangePasswordSheet
Future<void> showChangePasswordSheet(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const ChangePasswordDialog(),
  );
}