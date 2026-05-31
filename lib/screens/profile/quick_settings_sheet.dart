import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/local_storage.dart';
import '../../providers/app_providers.dart';
import '../home/home.dart';

class QuickSettingsSheet extends ConsumerWidget {
  const QuickSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    // ← FIX: was hardcoded HomeColors.deepAnchor — ignored dark mode
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    final titleColor = isDark ? cs.onSurface : HomeColors.deepAnchor;
    final iconColor = isDark ? cs.primary : HomeColors.heritagePurple;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(isDark: isDark, cs: cs),
          SizedBox(height: 20.h),
          Text(
            'Quick Settings',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: titleColor, // ← FIX
            ),
          ),
          SizedBox(height: 20.h),

          // Dark mode toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Icon(
              settings.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: iconColor, // ← FIX
            ),
            title: Text(
              'Dark Mode',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              settings.isDarkMode ? 'Dark theme active' : 'Light theme active',
              style: TextStyle(fontSize: 13.sp),
            ),
            value: settings.isDarkMode,
            activeColor: iconColor,
            onChanged: (val) async {
              ref.read(appSettingsProvider.notifier).toggleDarkMode();
              await LocalStorage.setDarkMode(val);
            },
          ),

          // Notifications toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Icon(
              Icons.notifications_outlined,
              color: iconColor, // ← FIX
            ),
            title: Text(
              'Notifications',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              settings.notificationsEnabled ? 'Enabled' : 'Disabled',
              style: TextStyle(fontSize: 13.sp),
            ),
            value: settings.notificationsEnabled,
            activeColor: iconColor,
            onChanged: (_) =>
                ref.read(appSettingsProvider.notifier).toggleNotifications(),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle({required bool isDark, required ColorScheme cs}) {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          // ← FIX: was hardcoded Colors.grey[300]
          color: isDark ? cs.onSurface.withOpacity(0.2) : Colors.grey[300],
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

/// Helper to show this sheet from anywhere
Future<void> showQuickSettingsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) => const QuickSettingsSheet(),
  );
}