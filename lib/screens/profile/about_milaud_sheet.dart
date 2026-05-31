import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home/home.dart';

class AboutMilaudSheet extends StatelessWidget {
  const AboutMilaudSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _cs = _theme.colorScheme;
    final _titleColor = _isDark ? _cs.onSurface : HomeColors.deepAnchor;
    final _accentColor = _isDark ? _cs.primary : HomeColors.heritagePurple;
        return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(),
          SizedBox(height: 20.h),

          // App identity row
          Row(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: HomeColors.heritagePurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.account_balance_outlined,
                  color: _accentColor,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Milaud',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: _titleColor,
                    ),
                  ),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),
          Text(
            'Milaud is a participatory governance mobile application designed for Milaor, Camarines Sur residents. It provides real-time announcements, citizen reporting, emergency alerts, document requests, and AI-powered assistance — all in one platform.',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF616161),
              height: 1.6,
            ),
          ),

          SizedBox(height: 20.h),
          _aboutRow(
            icon: Icons.code_outlined,
            label: 'Built with',
            value: 'Flutter + Supabase',
            titleColor: _titleColor,
          ),
          SizedBox(height: 10.h),
          _aboutRow(
            icon: Icons.location_city_outlined,
            label: 'Municipality',
            value: 'Milaor, Camarines Sur',
            titleColor: _titleColor,
          ),
          SizedBox(height: 10.h),
          _aboutRow(
            icon: Icons.school_outlined,
            label: 'Purpose',
            value: 'Academic Final Defense Project',
            titleColor: _titleColor,
          ),

          SizedBox(height: 20.h),
          const Divider(),
          SizedBox(height: 12.h),
          Text(
            'This application is developed for academic purposes. All resident data is stored securely and used solely for governance services.',
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

  Widget _aboutRow(
      {required IconData icon,
      required String label,
      required String value,
      required Color titleColor}) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: HomeColors.heritagePurple),
        SizedBox(width: 10.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF9E9E9E),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
      ],
    );
  }
}

/// Helper to show this sheet from anywhere
Future<void> showAboutMilaudSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) => const AboutMilaudSheet(),
  );
}