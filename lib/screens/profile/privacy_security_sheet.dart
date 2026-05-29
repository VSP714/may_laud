import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/app_providers.dart';
import '../home/home.dart';

class PrivacySecuritySheet extends ConsumerWidget {
  const PrivacySecuritySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(),
          SizedBox(height: 20.h),
          Text(
            'Privacy & Security',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: HomeColors.deepAnchor,
            ),
          ),
          SizedBox(height: 20.h),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Icon(
              Icons.location_on_outlined,
              color: HomeColors.heritagePurple,
            ),
            title: Text(
              'Location Access',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              settings.locationEnabled
                  ? 'Enabled — used for flood zone detection'
                  : 'Disabled',
              style: TextStyle(fontSize: 13.sp),
            ),
            value: settings.locationEnabled,
            activeColor: HomeColors.heritagePurple,
            onChanged: (_) =>
                ref.read(appSettingsProvider.notifier).toggleLocation(),
          ),
          Divider(height: 24.h),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.delete_outline,
              color: Color(0xFFD32F2F),
            ),
            title: Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFD32F2F),
              ),
            ),
            subtitle: Text(
              'Permanently remove your data',
              style: TextStyle(fontSize: 13.sp),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              size: 22.sp,
              color: const Color(0xFFBDBDBD),
            ),
            onTap: () {
              Navigator.pop(context);
              _showDeleteAccountDialog(context);
            },
          ),
          SizedBox(height: 8.h),
          Text(
            'Your data is securely stored and never shared with third parties without your consent.',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF9E9E9E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Delete Account',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFD32F2F),
          ),
        ),
        content: Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF616161),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF757575),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      'Account deletion requires admin approval. Contact support.'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  margin: EdgeInsets.all(12.w),
                ),
              );
            },
            child: Text(
              'Delete',
              style:
                  TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

/// Helper to show this sheet from anywhere
Future<void> showPrivacySecuritySheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) => const PrivacySecuritySheet(),
  );
}